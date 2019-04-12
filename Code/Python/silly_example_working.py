
# Import some key libraries:
import numpy as np
import dill as pickle                   # Next-generation serialization of Python objects. I expect it
import multiprocessing
from joblib import Parallel, delayed
from functools import total_ordering


# Create some trivially different types of agents:

# The "base" agent is a Tinker. Come on, everyone prolly has to be a tinker at
# some level right?

# Gonna use the ""@total_ordering" decorator to tell Python how to simply
# compare and order agents of the same type. Oh, actually, we'll find out if
# this works for inherited types...
# Reason to do this: we're gonna send these guys out over a multiprocessing call,
# and I want to be able to force them to be returned in the same order.
# NOTE: may acually not be needed, but is nice insurance until I dig deeper...
@total_ordering
class Tinker(object):

    def __lt__(self, other):
        return (self.i < other.i)

    def __init__(self, name, i):
        self.i=i  # We'll use this to confirm things...
        self.name=name
        self.mytype="Tinker"
        self.sum = None
        self.range = range(10)

    def say_hello(self, extra_message=None):
        print "Hello, my name is", self.name, "and my type is", self.mytype, "which is apparently related to summing N="+str(len(self.range))+" consecutive numbers, 0,1,2...,N"
        print "My sum is:", sum(self.range)
        if extra_message is not None:
            print "Oh and by the way:", extra_message
        print "\n"


class Tailor(Tinker):

    def __init__(self, *args, **kwargs):
        # Run the init function of the parent class:
        Tinker.__init__(self, *args, **kwargs)
        self.mytype="Tailor"
        self.range = range(20)

class Soldier(Tinker):

    def __init__(self, *args, **kwargs):
        # Run the init function of the parent class:
        Tinker.__init__(self, *args, **kwargs)
        self.mytype="Soldier"
        self.range = range(40)


class Spy(Tinker):

    def __init__(self, *args, **kwargs):
        # Run the init function of the parent class:
        Tinker.__init__(self, *args, **kwargs)
        self.mytype="Spy"
        self.range = range(60)


# Define a new class that is just a container for holding agents:
class SomeAgents(object):

    def __init__(self, list_of_agents):
        self.agents = list_of_agents
        self.saved_agent = self.agents[0]  # Save one to reference later...

        # Figure out number of cores to use:
        self.num_jobs = multiprocessing.cpu_count()  # USE ALL CORES

    def tell_agents_do_stuff_loop(self):
        for agent in self.agents:
            agent.say_hello("I'm  ~~on a boat~~  in a loop!")

    def tell_agents_do_stuff_parallel(self):

        # Build a list of dicts of args to pass in to each agent:
        list_of_args_per_agent = []
        for agent in self.agents:
            list_of_args_per_agent.append({'extra_message':"I'm multiprocessing!"})

        # Now call parallel call to send off all agents to different cores...
        results =  Parallel(n_jobs=self.num_jobs)(delayed(parallel_helper)(*args) for args in zip(self.agents, list_of_args_per_agent))

        # Make sure the new list is sorted correctly:
        self.agents = sorted(results)   # *This* is where @total_ordering is used

        # Just for kicks, check to see if the first agent in self.agents is the
        # same agent as before -- note that I believe it *shouldn't be*, because
        # we overwrote the agents with their copies. All data should be the same
        # but agents sit at different places in memory (and notmally I
        # delete the other copy:
        if self.agents[0] is self.saved_agent:
            print "You know nothing.."
        else:
            print "You're a wizard Harry!"


# Define parallel helper function:
def parallel_helper(obj, *args, **kwargs):
    # Execute the method we want to run in parallel:
    obj.say_hello(*args, **kwargs)
    obj.new_attribute = args[0]
    # Return the object -- note this will now be a copy -- bit-for-bit copy(ish), but different memory address
    return obj


# Because parallelization of any type cannot handle super "deep" calls, I
# define a simple function which simply tells an agent to execute a particular
# method.
# This was one of the original reasons we "flattened" the HACK code, so every
# aspect could be parallelized if we wanted. But guess what, only need targeted
# parallelization...


if __name__ == "__main__":

    # Define a list of different agent types
    MyTypes = [Tinker("Malinda", 0), Tailor("Jeff", 0), Soldier("Alice", 0), Spy("Bob", 0)]

    # Create the object collective
    agent_collective = SomeAgents(MyTypes)

    # Tell agents to do stuff in a loop
    agent_collective.tell_agents_do_stuff_loop()
    
    # Tell agents to do stuff in parallel
    # Note print doesn't really work as expected in parallel, but the code
    # is indeed running.  You can tell by looking at new_attribute
    agent_collective.tell_agents_do_stuff_parallel()
    print('Proof the code is running', agent_collective.agents[0].new_attribute)
