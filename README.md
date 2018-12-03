
# Ph.D. Proposal

<https://acuarica.gitlab.io/phd-proposal/phd-proposal.pdf>

## Thesis TODOs

* TODO: Talk about reflection as a way to /escape/ the type system, then talk about casting as a subset of reflection
* TODO: Add discussion from <https://martinfowler.com/bliki/DynamicTyping.html>
* TODO: Discuss "Static Typing of Complex Presence Constraints in Interfaces" \cite{oostvogelsStaticTypingComplex2018a}
* TODO: Source of information for cast success: Config files, libraries, more complex analysis
* TODO: What does the compiler need to know to assert that a cast won't fail at runtime?
* TODO: Include type system soundness discussion for thesis
* TODO: Find examples where \code{instanceof} is right and wrong
* TODO: Quantify patterns, Qualitative data
* TODO: Expand comment on usages of C \code{goto}s in GitHub (similar to our cast study)
* TODO: What conclusions did they draw on JNI usage?
* TODO: Expand discussion on static vs. dynamic analyses for these kinds of studies
* TODO: How many JEPs have been adopted since 2015?
* TODO: Discuss "static vs. dynamic" over "staging-time vs. compile-time vs. link-time vs. load-time vs. run-time"
* TODO: Preliminary discussion about `checkcast` and `instanceof` bytecodes
* TODO: Comment about why source code is necessary: upcasts are lost during compilation
* TODO: Add Code Recommenders Systems Codota/Kite https://www.codota.com/
* TODO: Patterns discussion `Selection`: Implicits in Scala
* TODO: Pattern discussion `Pattern Matching`: Jurgen Vinju paper <http://homepages.cwi.nl/~storm/publications/visitor.pdf>
* TODO: Methodology should be reproducible by other people leading to the same results
* TODO: Cast study coverage
* TODO: Address Antonio's comment on casting is not circumventing the static type system: Dynamically recovery information
* TODO: Make a case for the complexity of Engineering for compiling/dependencies for static analysis
* TODO: Expand on study about the source of exceptions, showing CCE being a problem for developers
* TODO: Pattern Dynamic Proxy: Paper "Static Analysis of Java Dynamic Proxies"
* TODO: Literature Review: Article "Static Typing Where Possible, Dynamic Typing When Needed: The End of the Cold War Between Programming Languages"
* TODO: Discussion about *strong typing* in "On understanding types, data abstraction, and polymorphism"
* TODO: Discuss why `classInstanceValue` (square/leakcanary) is not analyzable, deserialization pattern
* TODO: Discuss about `findViewById`: Partial solutions in other languages

## Literature Review: Add to introduction

* Users/Compilers Java/Scala generated bytecode

But there is more than empirical studies at the source code level.
A machine instruction set is effectively another kind of language.
Therefore, its design can be affected by how compilers generate machine code.
Several studies targeted the \jvm{}~\cite{collberg_empirical_2007,odonoghue_bigram_2002,antonioli_analysis_1998}; while~\cite{cook_empirical_1989} did a similar study for \lilith{} in the past.

## Antonio's comments on the proposal

My first and perhaps most important objections are on the premise of
the main research questions, namely that casting and unsafe are
mechanism used to circumvent the type system.

In particular, I would argue that a down-cast is not a way to
circumvent the type system, but rather a perfectly clear and
straightforward way to work /within/ the type system.

The /Unsafe/ mechanism can do a lot more than messing around with
types, so I wonder in what way the use of /Unsafe/ can be
characterized as a way to circumvent the type system.  Of the 14 usage
patterns listed in Table 3.1, only two have something to do with the
type system, namely throwing undeclared exceptions and updating
/final/ fields -- and those don't seem to be significant breaches of
the type systems anyway.

The examples listed in Section 4.1 don't seem to indicate problems
with the type system.  In other words, here ClassCast exceptions
not fundamentally different from, say, NullPointer exceptions.

The percentage of /indirect/ use of /Unsafe/ is not am indication of
the prevalence of bugs, let alone the prevalence of bugs that are
actually due to the use of /Unsafe/.  Perhaps you should look into
that.

It seems to me that you are focusing on a syntactic or anyway
low-level aspect of the use of a programming language.  You should
instead focus on the /semantics/ of a particular use of a language
feature.  For example, you could ask, how often and in what cases do
programmers use bound checks (in using arrays), and are those bad,
perhaps because they make the code less readable, or they are
unnecessary, because the checks are provably unnecessary.

You say that performance is the main motivation for the uses of
Unsafe.  I would argue that the main motivation is instead another
typical one: supporting various forms of application instrumentation
or other application-independent services (e.g., a checkpointing
library).

You say you focus on high-impact uses/features, but you seem to only
use static analysis.  Have you thought about measuring how often
/Unsafe/ is actually used, meaning /dynamically/?  Another, perhaps
more interesting question is how often those uses are identified as
the root cause of failures.

## Gabriele's comments on the proposal

* Chapter 3, only 1% of the projects (817 out of 86k) use the Unsafe API, but they use it a lot (48k usages). Why?

* Is the usage of the Unsafe API a form of technical debt? If yes, do you expect developers to refactor the code using the Usafe API?

* Comment on the limitation of the study in Chapter 3 related to the selection of the subject systems (libraries only)

* Clarify the manual process used to define the taxonomy in Chapter 3 (e.g., what is the confidence level/interval of the manually analyzed sample? how many evaluators have been involved in the process? how did you solve conflicts between evaluators? etc.)

* It would be interesting to look not only to commits fixing a ClassCastException, but also in code review repositories/issue trackers to analyze the developers’ discussion and extract the rationale behind some implementation choices.

* Consider using the explicit link existing in GitHub between commits and issues to only analyze bug-fixing commits related to ClassCastException (and automatically exclude commits unrelated to bug-fixing activities).

* Look at the 2019 MSR challenge dataset. It reports discussions on Stack Overflow including their code snippets linked to projects in GitHub. You can see whether a given code snippet in SO has been reused in GitHub projects and this can give you some hints on why developers use the Unsafe API or some type cast patterns.

# Sampling

N = Total number of casts to analyze: 9,030,852
K = Total number of casts of the least used pattern
n = Sample size to select
k = Times we saw the least used cast from the sample: 0 meaning we do not see it in our sample