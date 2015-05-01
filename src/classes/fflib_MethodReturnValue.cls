/**
 * Copyright (c) 2014, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
@isTest
public with sharing class fflib_MethodReturnValue
{
	private List<fflib_ArgumentMatcher> m_matchers;
	private List<Object> m_returnValueList;
	private boolean m_matcherSet = false;
	/**
	 * Class defining a method return value.
	 */
	public Object ReturnValue
	{
		get
		{
			if(m_returnValueList.size() == 0) return null;
			if(m_returnValueList.size() == 1) return m_returnValueList[0];
			return m_returnValueList.remove(0);
		}
	}

	public List<fflib_ArgumentMatcher> Matchers
	{
		get
		{
			return m_matchers;
		}
	}

	public fflib_MethodReturnValue()
	{
		m_matchers = new List<fflib_ArgumentMatcher>();
		m_matchers.add(Is.exactValue());
		m_returnValueList = new List<Object>();
	}

	/**
	 * Setup a stubbed return value.
	 * @param value The value to return from the stubbed method call.
	 */
	public fflib_MethodReturnValue thenReturn(Object value)
	{
		m_returnValueList.add(value);
		return this;
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1)
	{
		return it(matcher1, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2)
	{
		return it(matcher1, matcher2, null, null, null, null, null, null, null, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3)
	{
		return it(matcher1, matcher2, matcher3, null, null, null, null, null, null, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4)
	{
		return it(matcher1, matcher2, matcher3, matcher4, null, null, null, null, null, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, null, null, null, null, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, null, null, null, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, matcher7, null, null, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7, fflib_ArgumentMatcher matcher8)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, matcher7, matcher8, null, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7, fflib_ArgumentMatcher matcher8, fflib_ArgumentMatcher matcher9)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, matcher7, matcher8, matcher9, null, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7, fflib_ArgumentMatcher matcher8, fflib_ArgumentMatcher matcher9, fflib_ArgumentMatcher matcher10)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, matcher7, matcher8, matcher9, matcher10, null, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7, fflib_ArgumentMatcher matcher8, fflib_ArgumentMatcher matcher9, fflib_ArgumentMatcher matcher10, fflib_ArgumentMatcher matcher11)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, matcher7, matcher8, matcher9, matcher10, matcher11, null, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7, fflib_ArgumentMatcher matcher8, fflib_ArgumentMatcher matcher9, fflib_ArgumentMatcher matcher10, fflib_ArgumentMatcher matcher11, fflib_ArgumentMatcher matcher12)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, matcher7, matcher8, matcher9, matcher10, matcher11, matcher12, null, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7, fflib_ArgumentMatcher matcher8, fflib_ArgumentMatcher matcher9, fflib_ArgumentMatcher matcher10, fflib_ArgumentMatcher matcher11, fflib_ArgumentMatcher matcher12, fflib_ArgumentMatcher matcher13)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, matcher7, matcher8, matcher9, matcher10, matcher11, matcher12, matcher13, null, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7, fflib_ArgumentMatcher matcher8, fflib_ArgumentMatcher matcher9, fflib_ArgumentMatcher matcher10, fflib_ArgumentMatcher matcher11, fflib_ArgumentMatcher matcher12, fflib_ArgumentMatcher matcher13, fflib_ArgumentMatcher matcher14)
	{
		return it(matcher1, matcher2, matcher3, matcher4, matcher5, matcher6, matcher7, matcher8, matcher9, matcher10, matcher11, matcher12, matcher13, matcher14, null);
	}

	public fflib_MethodReturnValue it(fflib_ArgumentMatcher matcher1, fflib_ArgumentMatcher matcher2, fflib_ArgumentMatcher matcher3, fflib_ArgumentMatcher matcher4, fflib_ArgumentMatcher matcher5, fflib_ArgumentMatcher matcher6, fflib_ArgumentMatcher matcher7, fflib_ArgumentMatcher matcher8, fflib_ArgumentMatcher matcher9, fflib_ArgumentMatcher matcher10, fflib_ArgumentMatcher matcher11, fflib_ArgumentMatcher matcher12, fflib_ArgumentMatcher matcher13, fflib_ArgumentMatcher matcher14, fflib_ArgumentMatcher matcher15)
	{
		if(!m_matcherSet){
			m_matchers.remove(0);
			m_matcherSet = true;
		}
		if(matcher1 != null) m_matchers.add(matcher1);
		if(matcher2 != null) m_matchers.add(matcher2);
		if(matcher3 != null) m_matchers.add(matcher3);
		if(matcher4 != null) m_matchers.add(matcher4);
		if(matcher5 != null) m_matchers.add(matcher5);
		if(matcher6 != null) m_matchers.add(matcher6);
		if(matcher7 != null) m_matchers.add(matcher7);
		if(matcher8 != null) m_matchers.add(matcher8);
		if(matcher9 != null) m_matchers.add(matcher9);
		if(matcher10 != null) m_matchers.add(matcher10);
		if(matcher11 != null) m_matchers.add(matcher11);
		if(matcher12 != null) m_matchers.add(matcher12);
		if(matcher13 != null) m_matchers.add(matcher13);
		if(matcher14 != null) m_matchers.add(matcher14);
		if(matcher15 != null) m_matchers.add(matcher15);
		return this;
	}

	/**
	 * Setup a stubbed exception.
	 * @param e The exception to throw from the stubbed method call.
	 */
	public void thenThrow(Exception e)
	{
		m_returnValueList.add(e);
	}
}