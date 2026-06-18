import sys

class Component ():
	def __init__ (self):
		self.vars = {}
		self.res = {}
		self.callbacks = {}
	
	def __call__ (self):
		callbacks = [(index, self.callbacks[index]) for index in self.callbacks]
		ordered = sorted (callbacks, key = lambda x: x[0])
		for callback in ordered:
			callback ()

	def __getitem__ (self, name):
		if name in self.vars:
			return self.vars[name]
		elif name in self.res:
			return self.res[name]
		else:
			print ('Item %s does not exist' % (name))
			sys.exit ()

	def __setitem__ (self, name, value):
		if name in self.vars:
			self.vars[name] = value
		elif name in self.res:
			self.res[name] = value
		else:
			print ('Item %s does not exist' % (name))
			sys.exit ()

