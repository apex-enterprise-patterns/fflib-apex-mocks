/*
 * Copyright (c) 2016, FinancialForce.com, inc
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

/**
 *	An invocation on a mock.
 *	A place holder for mock, the method that was called and the arguments that were passed.
 *	@group Core
 */
public with sharing class fflib_InvocationOnMock
{
	private fflib_QualifiedMethod qm;
	private fflib_MethodArgValues methodArg;
	private Object mockInstance;

	/**
	 *	Constructor for the class.
	 *  @param qm The fflib_QualifiedMethod instance to be stored.
	 *  @param args The fflib_MethodArgValues instance to be stored.
	 *  @param mockInstance The mock instance to be stored.
	 */
	public fflib_InvocationOnMock(fflib_QualifiedMethod qm, fflib_MethodArgValues args, Object mockInstance)
	{
		this.qm = qm;
		this.methodArg = args;
		this.mockInstance = mockInstance;
	}

	/**
	 *	Returns the argument at the given index.
	 *  @param index The index of the wanted argument.
	 *  @throws ApexMocksException in case the index is out of range.
	 *  @return The argument at the given index.
	 */
	public Object getArgument(Integer index)
	{
		validateIndex(index);
		return methodArg.argValues[index];
	}

	/**
	 *	Returns the list of arguments passed to the method.
	 *  @return The list of arguments.
	 */
	public List<Object> getArguments()
	{
		return methodArg.argValues;
	}

	/**
	 *	Returns fflib_MethodArgValues instance that represents the arguments passed to the method.
	 *  @return The fflib_MethodArgValues instance that represents the arguments passed to the method.
	 */
	public fflib_MethodArgValues getMethodArgValues()
	{
		return methodArg;
	}

	/**
	 *	Returns the fflib_QualifiedMethod instance that represent the fully qualified method called within the invocation.
	 *	@return The method stored in the invocation.
	 */
	public fflib_QualifiedMethod getMethod()
	{
		return qm;
	}

	/**
	 *	Returns the mock object on which the invocation occurs.
	 *	@return The mock object on which the invocation occurs.
	 */
	public Object getMock()
	{
		return mockInstance;
	}

	private void validateIndex(Integer index)
	{
		if(index < 0 || index >= methodArg.argValues.size())
		{
			throw new fflib_ApexMocks.ApexMocksException('Invalid index, must be greater or equal to zero and less of ' + methodArg.argValues.size()+'.');
		}
	}
}