@isTest
public class fflib_Mocks
{
	public class Mockfflib_MyList implements fflib_MyList.IList
	{
		private fflib_ApexMocks mocks;

		public Mockfflib_MyList(fflib_ApexMocks mocks)
		{
			this.mocks = mocks;
		}

		public void add(String value)
		{
			if (mocks.Verifying)
			{
				mocks.verifyMethodCall(this, 'add', new List<Object> {value});
			}
			else
			{
				mocks.recordMethod(this, 'add', new List<Object> {value});
			}
		}

		public String get(Integer index)
		{
			if (mocks.Verifying)
			{
				mocks.verifyMethodCall(this, 'get', new List<Object> {index});
			}
			else if (mocks.Stubbing)
			{
				mocks.prepareMethodReturnValue(this, 'get', new List<Object> {index});
				return null;
			}
			else
			{
				mocks.recordMethod(this, 'get', new List<Object> {index});

				fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'get', new List<Object> {index});

				if (methodReturnValue != null)
				{
					if (methodReturnValue.ReturnValue instanceof Exception)
					{
						throw ((Exception) methodReturnValue.ReturnValue);
					}

					return (String) methodReturnValue.ReturnValue;
				}
			}

			return null;
		}

		public String get2(Integer index, String value)
		{
			if (mocks.Verifying)
			{
				mocks.verifyMethodCall(this, 'get2', new List<Object> {index, value});
			}
			else if (mocks.Stubbing)
			{
				mocks.prepareMethodReturnValue(this, 'get2', new List<Object> {index, value});
				return null;
			}
			else
			{
				mocks.recordMethod(this, 'get2', new List<Object> {index, value});

				fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'get2', new List<Object> {index, value});

				if (methodReturnValue != null)
				{
					if (methodReturnValue.ReturnValue instanceof Exception)
					{
						throw ((Exception) methodReturnValue.ReturnValue);
					}

					return (String) methodReturnValue.ReturnValue;
				}
			}

			return null;
		}

		public void clear()
		{
			if (mocks.Verifying)
			{
				mocks.verifyMethodCall(this, 'clear', new List<Object> {});
			}
			else
			{
				mocks.recordMethod(this, 'clear', new List<Object> {});
			}
		}

		public Boolean isEmpty()
		{
			if (mocks.Verifying)
			{
				mocks.verifyMethodCall(this, 'isEmpty', new List<Object> {});
			}
			else if (mocks.Stubbing)
			{
				mocks.prepareMethodReturnValue(this, 'isEmpty', new List<Object> {});
				return null;
			}
			else
			{
				mocks.recordMethod(this, 'isEmpty', new List<Object> {});

				fflib_MethodReturnValue methodReturnValue = mocks.getMethodReturnValue(this, 'isEmpty', new List<Object> {});

				if (methodReturnValue != null)
				{
					if (methodReturnValue.ReturnValue instanceof Exception)
					{
						throw ((Exception) methodReturnValue.ReturnValue);
					}

					return (Boolean) methodReturnValue.ReturnValue;
				}
			}

			return null;
		}

		public void set(Integer index, Object value)
		{
			if (mocks.Verifying)
			{
				mocks.verifyMethodCall(this, 'set', new List<Object> {index, value});
			}
			else
			{
				mocks.recordMethod(this, 'set', new List<Object> {index, value});
			}
		}
	}
}
