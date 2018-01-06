package scalazio

import scalaz.effect._
import scalaz.effect.console._

object ScalazIO extends SafeApp {
  def run(args: List[String]): IO[Unit] =
		for {
			_ <- putStrLn("What is your name?")
			n <- getStrLn
			_ <- putStrLn("Hello, " + n)
			_ <- IO.sync(System.exit(0))
		} yield ()
}
