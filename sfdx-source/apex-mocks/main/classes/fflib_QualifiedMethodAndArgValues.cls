/*
 Copyright (c) 2016-2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 * @group Core
 */
@NamespaceAccessible
public with sharing class fflib_QualifiedMethodAndArgValues
{
	private final fflib_QualifiedMethod qm;
	private final fflib_MethodArgValues args;
	private final Object mockInstance;

	@NamespaceAccessible
	public fflib_QualifiedMethodAndArgValues(fflib_QualifiedMethod qm, fflib_MethodArgValues args, Object mockInstance)
	{
		this.qm = qm;
		this.args = args;
		this.mockInstance = mockInstance;
	}

	@NamespaceAccessible
	public fflib_QualifiedMethod getQualifiedMethod()
	{
		return qm;
	}

	@NamespaceAccessible
	public fflib_MethodArgValues getMethodArgValues()
	{
		return args;
	}

	@NamespaceAccessible
	public Object getMockInstance()
	{
		return mockInstance;
	}

	@NamespaceAccessible
	public override String toString()
	{
		return qm + ' with args: [' + String.join(args.argValues, '],[') + ']';
	}
}