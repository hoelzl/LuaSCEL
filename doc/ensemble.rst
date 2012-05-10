==============================================================
Communication Strategies and Ensemble Representation in SCELua
==============================================================

:Author:
  Matthias Hölzl
:Version:
  0.1
:Date:
  2012-03-23


Introduction
============

SCELua is meant to be useful for at least three different tasks:

* Stand-alone SCEL programs
* Scripting the ASCENS science cloud
* Programming robots in the ARGoS simulator and in hardware

To be useful for all three scenarios we need to have some flexibility
in how we set up the initial ensemble, how we create new components at
run time (if this is possible at all), and how we handle network
communications.

Stand-alone SCEL Programs
-------------------------

Here we are basically free to do whatever we want about the
representation of the ensemble and about the scheduling of individual
components.  A simple implementation might have a table containing
descriptions of all components in the ensemble and the ensemble-wide
policies, as well as global scheduler that uses coroutines to run the
individual components.  In this case each component has to return
control to the ensemble after performing a few actions, otherwise
things won't work.

A more complex setup would be to run each component in its own thread
(and therefore its own Lua interpreter), and to use sockets or 0mq to
perform communication between components.

Science Cloud
-------------

Here different components necessarily run in different processes (most
likely even different computers) if they belong to different nodes.
Thus there is no alternative to separate processes, marshaling of
data and remote communication.  A global view of the ensemble seems to
be impossible in general, so each component has to make do with a
local view of the ensemble.


Robots
------

When running in the ARGoS simulator, the components running on a
single robot can be scheduled in any manner, but the components of
different robots run sequentially in each simulation step;
communication between robots will have to be managed by the event
loop.  Therefore, communication has to be stored and processed by the
event loop; communicating via sockets or 0mq does not seem to be
possible in that case. 

When running on the real robots things are different: here, as in the
science cloud, we need to communicate remotely, but in this case
mostly via unreliable communication links.  In this case, a view of
the whole ensemble is again not practical.


Design
======

