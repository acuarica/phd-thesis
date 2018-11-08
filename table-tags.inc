%% AUTOMATICALLY GENERATED FROM `casts.ql` & `qldoc.js`. DO NOT EDIT!!!


% \begin{tabularx}{\linewidth}{rp{9.25cm}cccccccX}
\begin{tabularx}{\linewidth}{rlp{8.5cm}rX}
\hdr \# & \textbf{Tag} & \textbf{Description} & \textbf{Count} \\
\row 1 & \ctag{Param} & A cast applied to a formal parameter. & 363 \\ 
\alt 2 & \ctag{LocalVar} & The expression of the cast is a local variable. & 185 \\ 
\row 3 & \ctag{Field} & The expression of the cast is a field (class or instance variable). & 92 \\ 
\alt 4 & \ctag{DefUse} & The expression of the cast is a variable which was assigned before in the same method. & 150 \\ 
\row 5 & \ctag{TypeSwitch} & This cast is part of a type switch (chained \code{instanceof}s) test. & 0 \\ 
\alt 6 & \ctag{VarControlledByIsArray} & A cast controlled by \code{java.lang.Class::isArray}. & 0 \\ 
\row 7 & \ctag{Null} & A cast applied to the \code{null} literal, \ie{}, \code{(String[]) null}. & 106 \\ 
\alt 8 & \ctag{ExplicitVarargsArray} & A cast used as an argument, is an array of the appropriate type passed to a \emph{varargs} parameter. & 0 \\ 
\row 9 & \ctag{Vararg} & A cast used as an argument is part of an implicit \emph{varargs} array. & 0 \\ 
\alt 10 & \ctag{Overloaded} & A cast used as an argument of an overloaded method. & 0 \\ 
\row 11 & \ctag{New} & A cast applied to a \code{new} expression. & 0 \\ 
\alt 12 & \ctag{Return} & A cast used in a \code{return} statement. & 0 \\ 
\row 13 & \ctag{Throw} & A cast used in a \code{throw} statement. & 0 \\ 
\alt 14 & \ctag{Singleton} & A cast in a single statement callable. & 0 \\ 
\row 15 & \ctag{UncheckedCallable} & A cast's method is marked unchecked. & 0 \\ 
\alt 16 & \ctag{UncheckedVarDecl} & A cast's used in a variable declaration is marked unchecked. & 0 \\ 
\row 17 & \ctag{This} & A cast to the \code{this} reference. & 9 \\ 
\alt 18 & \ctag{TypeVar} & A cast into a type parameter. & 0 \\ 
\row 19 & \ctag{InOverride} & This cast is in a overridden method. & 412 \\ 
\alt 20 & \ctag{InEquals} & This cast is in an \code{equals} method. & 76 \\ 
\row 21 & \ctag{InClone} & This cast is in a \code{clone} method. & 2 \\ 
\alt 22 & \ctag{InTest} & This cast is in a test method of a common testing framework (including JUnit and TestNG). & 360 \\ 
\row 23 & \ctag{ReflectiveInvokeMethod} & A cast applied to \code{java.lang.reflect.Method::invoke}. & 0 \\ 
\alt 24 & \ctag{ReflectiveGetField} & A cast applied to \code{java.lang.reflect.Field::get}. & 0 \\ 
\row 25 & \ctag{DynamicNewInstance} & Call site to one of the \code{newInstance}s methods in the \code{Class}, \code{Array}, or \code{Constructor} classes. & 0 \\ 
\alt 26 & \ctag{IntoObject} & Cast an expression into \code{Object}. & 21 \\ 
\row 27 & \ctag{IntoInterface} & Casts an expression into an interface. & 344 \\ 
\alt 28 & \ctag{IntoParameterizedType} & Casts an expression into a parameterized type, \eg{}, \code{(Answer<T>) new ReturnsArgumentAt(1)}. & 0 \\ 
\row 29 & \ctag{ReadObject} & A cast to read objects on type \code{java.io.ObjectInputStream}. & 13 \\ 
\alt 30 & \ctag{Samecast} & The type of the expression applied to the cast and the type casted to are the same. & 0 \\ 
\row 31 & \ctag{Upcast} & An upcast, \ie{}, the expression of the cast is a supertype of the type casted to. & 84 \\ 
\hline
\end{tabularx}
