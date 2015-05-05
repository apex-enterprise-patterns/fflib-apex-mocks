public with sharing class Is {

	static public fflib_ArgumentMatcher anyString()
	{
		return new ArgumentMatcherAnyString();
	}

	static public fflib_ArgumentMatcher anyInteger()
	{
		return new ArgumentMatcherAnyInteger();
	}

	static public fflib_ArgumentMatcher exactValue()
	{
		return new ArgumentMatcherExactValue();
	}

	static public fflib_ArgumentMatcher withinRange(Integer min, Integer max)
	{
		return new ArgumentMatcherWithinIntegerRange(min, max);
	}

	static public fflib_ArgumentMatcher anyBoolean()
	{
		return new ArgumentMatcherAnyBoolean();
	}

	static public fflib_ArgumentMatcher anyThing()
	{
		return new ArgumentMatcherAnyThing();
	}

	static public fflib_ArgumentMatcher anySObject()
	{
		return new ArgumentMatcherAnySObject();
	}

	public class ArgumentMatcherAnyString extends fflib_ArgumentMatcher
	{
		public override boolean matches()
		{
			if(RecievedArgument == null) return false;
			return RecievedArgument instanceof String;
		}
	}

	public class ArgumentMatcherAnyInteger extends fflib_ArgumentMatcher
	{
		public override boolean matches()
		{
			if(RecievedArgument == null) return false;
			return RecievedArgument instanceof Integer;
		}
	}

	public class ArgumentMatcherAnyBoolean extends fflib_ArgumentMatcher
	{
		public override boolean matches()
		{
			if(RecievedArgument == null) return false;
			return RecievedArgument instanceof Boolean;
		}
	}

	public class ArgumentMatcherAnyThing extends fflib_ArgumentMatcher
	{
		public override boolean matches()
		{
			return true;
		}
	}

	public class ArgumentMatcherAnySObject extends fflib_ArgumentMatcher
	{
		public override boolean matches()
		{
			if(RecievedArgument == null) return false;
			return RecievedArgument instanceof SObject;
		}
	}

	public class ArgumentMatcherExactValue extends fflib_ArgumentMatcher
	{
		public override boolean matches()
		{
			// Special case as the logic is not done here
			return true;
		}
	}

	public class ArgumentMatcherWithinIntegerRange extends fflib_ArgumentMatcher
	{

		private Integer m_min = 0;
		private Integer m_max = 0;

		public ArgumentMatcherWithinIntegerRange(Integer min, Integer max)
		{
			m_min = min;
			m_max = max;
		}

		public override boolean matches()
		{
			if(RecievedArgument == null) return false;
			if(!(RecievedArgument instanceof Integer)) return false;
			Integer myCheckValue = (Integer)RecievedArgument;
			return myCheckValue >= m_min && myCheckValue <= m_max;
		}
	}

}