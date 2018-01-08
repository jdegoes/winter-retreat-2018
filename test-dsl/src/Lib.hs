{-# LANGUAGE ExistentialQuantification #-}

module Lib
    ( example
    ) where

import Prelude hiding ((<*>))

import Data.Semigroup

data TestResult
  = Success String String
  | Failure String String

prettyResult :: TestResult -> String
prettyResult (Success v _) = "✓"
prettyResult (Failure v _) = "x " <> v

data Test f a
  = Append (Test f a) (Test f a)
  | Label String (Test f a)
  | Assert (f TestResult) (TestResult -> a)
  | forall a0. Map (Test f a0) (a0 -> a)
  | forall a1 a2. Zip (Test f a1) (Test f a2) ((a1, a2) -> a)

-- | Asserts some condition.
--
assert :: forall f. f TestResult -> Test f TestResult
assert fa = Assert fa id

-- | Labels a test with some string.
--
label :: forall f a. String -> Test f a -> Test f a
label = Label

-- | Asserts one thing equals another.
--
equals :: forall f a. (Monad f, Eq a, Show a) => a -> a -> f TestResult
equals a b = pure $
  (if a == b then Success else Failure)
    ("Expected " <> show a <> " but found " <> show b)
    ("Expected something other than " <> show a <> " but found " <> show b)

runTest :: forall a. Test IO a -> IO a
runTest = runTest0 0
  where
    indent i = putStr $ replicate i ' '

    runTest0 :: forall b. Int -> Test IO b -> IO b
    runTest0 i v = indent i *>
      case v of
        (Append l r) -> runTest0 i l *> runTest0 i r
        (Label s v) -> indent i *> putStrLn s *> runTest0 (i + 1) v
        (Assert fa f') -> indent i *> (fa >>= \t -> putStrLn (prettyResult t) *> pure (f' t))
        (Map v f') -> f' <$> runTest0 i v
        (Zip l r f') ->
          do
            l <- runTest0 i l
            r <- runTest0 i r
            pure $ f' (l, r)

class Functor f => Apply f where
  (<*>) :: forall a b. f (a -> b) -> f a -> f b

instance Semigroup (Test f a) where
  (<>) = Append

instance Functor f => Functor (Test f) where
  fmap f (Append l r) = Append (fmap f l) (fmap f r)
  fmap f (Label s v) = Label s (fmap f v)
  fmap f (Assert fa f') = Assert fa (f <$> f')
  fmap f (Map v f') = Map v (f <$> f')
  fmap f (Zip l r f') = Zip l r (f <$> f')

instance Functor f => Apply (Test f) where
  (<*>) l r = Zip l r (\t -> (fst t) (snd t))

example :: IO ()
example = do
  runTest $
    (label "The absurd must be false" $ assert $ equals 1 2) <>
    (label "The sane must be true" $ assert $ equals 1 1) <>
    (label "The sane must be true" $ assert $
      do
        putStrLn "Random effect"
        equals 1 0)
  return ()
