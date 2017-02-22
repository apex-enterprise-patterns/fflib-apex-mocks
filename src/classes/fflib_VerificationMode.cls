/*
 * Copyright (c) 2017, FinancialForce.com, inc
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
 *	This class implements the verification modes with Mockito syntax style.
 *	It can be used in the classic verify and in the ordered verify.
 *	@group Core
 */
public with sharing class fflib_VerificationMode
{
	public Integer VerifyMin {get; set;}
	public Integer VerifyMax {get; set;}
	public String CustomAssertMessage { get; set; }

	public enum ModeName {times, atLeast, atMost, between, atLeastOnce, calls}

	public ModeName Method;

	public fflib_VerificationMode()
	{
		VerifyMin = 1;
		VerifyMax = null;
		CustomAssertMessage = null;
		Method = null;
	}

	/**
	 * Sets how many times the method is expected to be called. Not available in the InOrder verification yet.
	 * @param times The number of times you expect the method to have been called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode times(Integer times)
	{
		this.Method = ModeName.times;
		this.VerifyMin = this.VerifyMax = times;
		return this;
	}

	/**
	 * Sets a custom assert message for the verify.
	 * @param customAssertMessage The custom message for the assert in case the assert is false. The custom message is queued to the default message.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode description(String customAssertMessage)
	{
		this.CustomAssertMessage = customAssertMessage;
		return this;
	}

	/**
	 * Sets the minimum number of times the method is expected to be called. Not available in the InOrder verification yet.
	 * @param atLeastTimes The minimum number of times you expect the method to have been called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode atLeast(Integer atLeastTimes)
	{
		this.Method = ModeName.atLeast;
		this.VerifyMin = atLeastTimes;

		return this;
	}

	/**
	 * Sets the maximum number of times the method is expected to be called. Not available in the InOrder verification yet.
	 * @param atMostTimes The maximum number of times the method is expected to be called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode atMost(Integer atMostTimes)
	{
		this.Method = ModeName.atMost;
		this.VerifyMax = atMostTimes;

		return this;
	}

	/**
	 * Sets that the method is called at least once. Not available in the InOrder verification yet.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode atLeastOnce()
	{
		this.Method = ModeName.atLeastOnce;
		this.VerifyMin = 1;

		return this;
	}

	/**
	 * Sets the range of how many times the method is expected to be called. Not available in the InOrder verification yet.
	 * @param atLeastTimes The minimum number of times you expect the method to have been called.
	 * @param atMostTimes The maximum number of times the method is expected to be called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode between(Integer atLeastTimes, Integer atMostTimes)
	{
		this.Method = ModeName.between;
		this.VerifyMin = atLeastTimes;
		this.VerifyMax = atMostTimes;

		return this;
	}

	/**
	 * Sets that the method is not expected to be called.
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode never()
	{
		this.VerifyMin = fflib_ApexMocks.NEVER;
		this.VerifyMax = fflib_ApexMocks.NEVER;

		return this;
	}

	/**
	 * Sets how many times the method is expected to be called for an InOrder verifier. Available Only with the InOrder verification.
	 * A verification mode using calls will not fail if the method is called more times than expected.
	 * @param callingTimes The number of times you expect the method to have been called in the InOrder verifying (no greedy verify).
	 * @return The fflib_VerificationMode object instance with the proper settings.
	 */
	public fflib_VerificationMode calls(Integer callingTimes)
	{
		this.Method = ModeName.calls;
		this.VerifyMin = this.VerifyMax = callingTimes;

		return this;
	}
}