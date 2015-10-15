##goRPN##
**goRPN** is a stack-based RPN calculator built in Swift. Like many of my pet projects, it started as a reimagining of a favorite old tool, in this case my (now-lost) [HP-16C](https://en.wikipedia.org/wiki/HP-16C) calculator. To allow for both floating-point and integer modes, I have implemented a generic `GoCalculator` class, which can be initialized with `Int`, `Float`, or `Double` types.

----------
## Contributing ##
I welcome questions on and contributions to the development of goRPN. It is also a laboratory for me to experiment with some of the more advanced capabilities of Swift, especially functional programming and the use of generics, protocols, and extensions. If you would like to contribute:

 1. Fork it!
 2. Create your feature branch: `git checkout -b my-new-feature`
 3. Commit your changes: `git commit -am 'Add some feature'`
 4. Push to the branch: `git push origin my-new-feature`
 5. Submit a pull request!

----------
##Credits##
[This Haskell implementation of an RPN stack](http://learnyouahaskell.com/functionally-solving-problems#reverse-polish-notation-calculator) got me started.
[This blog post](http://foxinswift.com/2015/08/17/cast-free-arithmetic/) helped me make the calculator section generic.

