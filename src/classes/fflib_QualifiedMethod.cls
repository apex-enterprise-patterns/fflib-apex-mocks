/*
 * Copyright (c) 2016-2017 FinancialForce.com, inc.  All rights reserved.
 */
public with sharing class fflib_QualifiedMethod
{
	public final Object mockInstance;
	public final String typeName;
	public final String methodName;
	public final List<Type> methodArgTypes;
	
	public fflib_QualifiedMethod(String typeName, String methodName, List<Type> methodArgTypes)
	{
		this(typeName, methodName, methodArgTypes, null);
	}

	public fflib_QualifiedMethod(String typeName, String methodName, List<Type> methodArgTypes, Object mockInstance)
	{
		this.mockInstance = mockInstance;
		this.typeName = typeName;
		this.methodName = methodName;
		this.methodArgTypes = methodArgTypes;	
	}
	
	/**
	 * Standard equals override.
	 * @param other The object whose equality we are verifying
	 * @return Boolean True if meaningfully equivalent, false otherwise.
	 */
	public Boolean equals(Object other)
	{
		if (this === other)
		{
			return true;
		}
		
		fflib_QualifiedMethod that = other instanceof fflib_QualifiedMethod ? (fflib_QualifiedMethod)other : null;
		
		return that != null
			&& (this.mockInstance === that.mockInstance || !fflib_ApexMocksConfig.HasIndependentMocks)
			&& this.typeName == that.typeName
			&& this.methodName == that.methodName
			&& this.methodArgTypes == that.methodArgTypes;
	}
	
	/**
	 * Standard hashCode override.
	 * @return Integer The generated hashCode
	 */
	public Integer hashCode()
	{
		Integer prime = 31;
		Integer result = 1;
		
		if (fflib_ApexMocksConfig.HasIndependentMocks)
		{
			result = prime * result + ((mockInstance == null) ? 0 : mockInstance.hashCode());
		}
		result = prime * result + ((methodArgTypes == null) ? 0 : methodArgTypes.hashCode());
		result = prime * result + ((methodName == null) ? 0 : methodName.hashCode());
		result = prime * result + ((typeName == null) ? 0 : typeName.hashCode());
		
		return result;
	}
	
	/**
	 * Standard toString override.
	 * @return String The human friendly description of the method.
	 */
	public override String toString()
	{
		return typeName + '.' + methodName + methodArgTypes;
	}

	/**
	 * Predicate describing whether the qualified method accepts arguments or not.
	 * @return True if the method accepts arguments.
	 */
	public Boolean hasArguments()
	{
		return this.methodArgTypes != null && !this.methodArgTypes.isEmpty();
	}
}