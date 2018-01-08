# test-dsl

A testing DSL that supports arbitrary annotation, semigroup composition of tests,
and applicative dependencies between tests.

# Exercises

1. Write a function `documentTest :: Test f a -> IO ()` to print out the
structure of a test without actually running any test.
2. Write a function `pruneTest :: String -> Test f a -> Test f a` that prunes
a test to those that contain the specified string as part of a label.
3. Generalize the example test runner so it runs independent tests in parallel.
4. Now only test results can be communicated between dependent tests. See if you
can fix this problem by reworking the definition of `Test`.
