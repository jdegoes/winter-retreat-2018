autoscale: true

# *Building a Test Library Using Apply Functors*
### Winter Retreat 2018 - Whistler, BC, Canada

#### John A. De Goes
#### @jdegoes - http://degoes.net

<https://github.com/jdegoes/winter-retreat-2018>

---

# *Agenda*

 * Unit Testing Sucks
 * Can We Do Something About It with FP?
 * Apply Functors

--- 

# *2nd Class Unit Testing*

```java
@Test
void myFirstTest() {
  assertEquals(e1, e2);
}
```

--- 

# *2nd Class Unit Testing*

```java
@BeforeEach
void setup() {
  ...
}

@Test
void myFirstTest() {
  ...
  assertEquals(e1, e2);
}
```

--- 

# *2nd Class Unit Testing*

```java
@BeforeEach
void setup() {
  ...
}

@Test
@DisplayName("Test the foo with the bar bazzing")
void myFirstTest() {
  ...
  assertEquals(e1, e2);
}
```

---

# *2nd Class Unit Testing*

```java
@BeforeEach
void setup() {
  ...
}

@Test
@DisplayName("Test the foo with the bar bazzing")
void myFirstTest() {
  ...
  assertEquals(e1, e2);
}


@TestFactory
Collection<DynamicTest> dynamicTests() {
  ...
}
```

---

# [fit] *Unit Testing Libraries Aren't Functional*

---

# *Unit Testing: Powered by FP*
#### 

 * Everything is a first class value
 * Everything is declarative rather than imperative
 * Everything is type safe, pure, & composable
 * **All goals can be achieved through composition**

---

# [fit] What Is a Test?

---

# [fit] What Is a Test Suite?

---

# [fit] What Is a Display Name?

---

# [fit] What Is a Test Harness?

---

# [fit] *ALL THE THINGS ARE VALUES*

---

# *Big Vision*
#### Structure of a Test


```haskell
        Test Result
            |
            |
data Test f a
          |
          |
    Effect Required
       By Test
```

---

# *Big Vision*
#### Running a Test


```haskell
data Test f a

runTest :: forall a. Test IO a -> IO a
```

---

# *Million Dollar Question*

> Given two tests, how should we compose them to get another test?

---

# *Semigroup Composition*
#### 0 to N

```haskell
(<>) :: Test f a -> Test f a -> Test f a

test1 <> test2 <> test3 <> ... <> testn
```

*Parallelism for free!

---

# *Sequential Composition*

> One test must depend upon the result of another test.

---

# *Monads*
#### Essence of Sequentiality

```haskell
class Applicative m => Monad m where
  (>>=) :: forall a b. m a -> (a -> m b) -> m b
                        ^      ^     ^       ^
                        |      |     |       |
                        |      |     |       |
                        |      |   Second    |
                        |      |  Program    |
                        |      |             |
                        | Runtime Value      |
                        |                    |
                  First Program        Result Program
```

---

# *Monads*
#### Bye-Bye Introspection


```haskell
class Applicative m => Monad m where
  (>>=) :: forall a b. m a -> (a -> m b) -> m b
                               ^
                               |
                               |
                               |
                               |
                               |
                           !@&#%&##$
```

---

# *Apply to the Rescue?*
#### Functor → *Apply* → Applicative → Bind → Monad

```scala
class Functor f => Apply f where
    (<*>) :: f (a -> b) -> f a -> f b
                  ^         ^      ^
                  |         |      |
                  |      Second    |
                  |      Program   |
            First Program          |
                             Result Program
```

No program depends on any runtime value: the structure is *static*s

---

# *Apply to the Rescue?*
#### A Caveat

`Apply` functors are *strictly less powerful* than monads. Static structure has a _cost_.

<br>

```haskell
f <$> fa <*> fb <*> fc
```

---

# *Workshop*

> Time to dig in. Can we build a testing DSL using Apply functors?

---

# THANK YOU!

### *John A. De Goes — @jdegoes*

<https://github.com/jdegoes/winter-retreat-2018>
