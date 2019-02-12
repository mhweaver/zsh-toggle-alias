zsh-toggle-alias
===============

A simple plugin that lets you expand and collapse ZSH aliases. 
It uses the alias discovery logic of `You Should Use`_ (which this plugin is forked from) to collapse a command into an alias.
If the command is already an alias, you can expand it into the full command, similar to `globalias`_

To expand/collapse an alias, hit ``ctrl``-``space``

Note: This should not be used alongside `globalias`_, unless you feel like changing the keybindings. It should play nicely with `You Should Use`_, though.

.. _You Should Use: https://github.com/MichaelAquilina/zsh-you-should-use
.. _globalias: https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/globalias
