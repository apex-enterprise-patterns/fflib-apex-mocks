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

	public class ArgumentMatcherAnyString extends fflib_ArgumentMatcher
	{
		public override boolean matches(Object valueToCheck)
		{
			if(valueToCheck == null) return false;
			return valueToCheck instanceof String;
		}
	}

	public class ArgumentMatcherAnyInteger extends fflib_ArgumentMatcher
	{
		public override boolean matches(Object valueToCheck)
		{
			if(valueToCheck == null) return false;
			return valueToCheck instanceof Integer;
		}
	}

	public class ArgumentMatcherExactValue extends fflib_ArgumentMatcher
	{
		public override boolean matches(Object valueToCheck)
		{
			// Special case
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

		public override boolean matches(Object valueToCheck)
		{
			if(valueToCheck == null) return false;
			if(!(valueToCheck instanceof Integer)) return false;
			Integer myCheckValue = (Integer)valueToCheck;
			return myCheckValue >= m_min && myCheckValue <= m_max;
		}
	}

}