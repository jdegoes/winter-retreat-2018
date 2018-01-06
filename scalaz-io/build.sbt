organization := "scalazio"
name := "ScalazIO"
version := "0.0.1"

scalaVersion := "2.12.4"
scalacOptions ++= List("-feature","-deprecation", "-unchecked", "-Xlint")

libraryDependencies ++= Seq(
  "org.scalatest"   %% "scalatest"    % "3.0.4"   % "test",
  "org.scalacheck" %% "scalacheck" % "1.13.4" % "test"
)

mainClass in (Compile, run) := Some("scalazio.ScalazIO")
