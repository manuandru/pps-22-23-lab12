package it.unibo.u12lab.code

import alice.tuprolog.*

import scala.Tuple

object Scala2P:

  def extractTerm(solveInfo:SolveInfo, i:Integer): Term =
    solveInfo.getSolution.asInstanceOf[Struct].getArg(i).getTerm

  def extractTerm(solveInfo:SolveInfo, s:String): Term =
    solveInfo.getTerm(s)

  given Conversion[String, Term] = Term.createTerm(_)
  given Conversion[Seq[_], Term] =  _.mkString("[",",","]")
  given Conversion[String, Theory] = Theory.parseLazilyWithStandardOperators(_)

  def mkPrologEngine(theory: Theory): Term => LazyList[SolveInfo] =
    val engine = Prolog()
    engine.setTheory(theory)

    goal => new Iterable[SolveInfo]{

      override def iterator = new Iterator[SolveInfo]{
        var solution: Option[SolveInfo] = Some(engine.solve(goal))

        override def hasNext = solution.isDefined &&
                              (solution.get.isSuccess || solution.get.hasOpenAlternatives)

        override def next() =
          try solution.get
          finally solution = if (solution.get.hasOpenAlternatives) Some(engine.solveNext()) else None
      }
    }.to(LazyList)


  def solveWithSuccess(engine: Term => LazyList[SolveInfo], goal: Term): Boolean =
    engine(goal).map(_.isSuccess).headOption == Some(true)

  def solveOneAndGetTerm(engine: Term => LazyList[SolveInfo], goal: Term, term: String): Term =
    engine(goal).headOption.map(extractTerm(_,term)).get


object TryScala2P extends App:
  import Scala2P.{*, given}

  val engine: Term => LazyList[SolveInfo] = mkPrologEngine("""
    goal(s(3,3)).
    move(down, s(X, Y), s(X2, Y)) :- X>0, X2 is X-1.
    move(up, s(X, Y), s(X2, Y)) :- X<3, X2 is X+1.
    move(left, s(X, Y), s(X, Y2)) :- Y>0, Y2 is Y-1.
    move(right, s(X, Y), s(X, Y2)) :- Y<3, Y2 is Y+1.
    plan(0, P, []) :- !, goal(P).
    plan(_, P, []) :- goal(P), !.
    plan(N, Pos, [D|T]) :-
      move(D, Pos, NewPos),
      N2 is N - 1,
      plan(N2, NewPos, T).
  """)


  engine("plan(8, s(0,0), R)") foreach { solveInfo =>
    val solList = solveInfo.getTerm("R").toString
      .replace("[", "")
      .replace("]", "")
      .split(",")
    import Utility.*
    var position = (0,0)
    println(solList.mkString("Solution = (", ",", ")")) // solution is upside-down due to prolog impl
    printPositionInBoard(position)
    solList.foreach(cmd =>
      position = cmd match
        case "up" => position.moveUp
        case "down" => position.moveDown
        case "right" => position.moveRight
        case "left" => position.moveLeft
      printPositionInBoard(position)
    )
    println("===================")
  }

object Utility:
  // quick and dirty solution...
  def printPositionInBoard(position: (scala.Int, scala.Int)): Unit =
    for
      x <- 0 to 3
      y <- 0 to 3
    do
      if y == 0 then print("\n|")
      if Tuple2(x,y) == position then print("R|")
      else print(" |")
    println()

  extension (t: (scala.Int, scala.Int))
    def moveUp: (scala.Int, scala.Int) = (t._1+1, t._2)
    def moveDown: (scala.Int, scala.Int) = (t._1-1, t._2)
    def moveRight: (scala.Int, scala.Int) = (t._1, t._2+1)
    def moveLeft: (scala.Int, scala.Int) = (t._1, t._2-1)





