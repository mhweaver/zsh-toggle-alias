zsh-toggle-alias
===============

A simple plugin that lets you expand and collapse ZSH aliases. 
It uses the alias discovery logic of `You Should Use`_ (which this plugin is forked from) to collapse a command into an alias.
If the command is already an alias, you can expand it into the full command, similar to `globalias`_

To expand/collapse an alias, hit ``ctrl``-``space``

----------------------
Caveats and known bugs
----------------------
* When collapsing aliases, only 1 alias is collapsed at a time, so you may need to hit ``ctrl``-``space`` several times to fully collapse your input.
* Nested aliases don't always fully expand/collapse, especially when using compound commands. For example, I have an alias ``grep=grep --color`` and a global alias ```G=| grep```. The input ``echo 1 | grep 1`` correctly collapses down to ``echo 1 G 1`. Hitting `ctrl``-``space`` again fully expands the `grep` alias when it expands `G`, producing ``echo 1 | grep --color 1``. Unfortunately, when we try to collapse this, we end up with ``echo 1 G --color 1``, which isn't right (the ``--color`` is already part of ``G``, due to the ``grep alias``). In this specific instance, it's because the plugin doesn't really handle compound commands, so it never tries to collapse the ``grep`` alias after the ``|``. And Even if it did handle the ``|``, it collapses global aliases before regular aliases, so the ``| grep`` would collapse down to ``G`` before bothering to deal with the ``grep --color`` part. 
* This should not be used alongside `globalias`_, unless you feel like changing the keybindings. It should play nicely with `You Should Use`_, though.

.. _You Should Use: https://github.com/MichaelAquilina/zsh-you-should-use
.. _globalias: https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/globalias
