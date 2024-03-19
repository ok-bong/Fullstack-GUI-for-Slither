pragma solidity 0.8.1;

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);


    function mint(address account_, uint256 amount_) external;

    function burn(uint256 amount) external;
    
}

interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        return _values(set._inner);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrrt(uint256 a) internal pure returns (uint256 c) {
        if (a > 3) {
            c = a;
            uint256 b = add(div(a, 2), 1);
            while (b < c) {
                c = b;
                b = div(add(div(a, b), b), 2);
            }
        } else if (a != 0) {
            c = 1;
        }
    }

    /*
     * Expects percentage to be trailed by 00,
     */
    function percentageAmount(uint256 total_, uint8 percentage_) internal pure returns (uint256 percentAmount_) {
        return div(mul(total_, percentage_), 1000);
    }

    /*
     * Expects percentage to be trailed by 00,
     */
    function substractPercentage(uint256 total_, uint8 percentageToSub_) internal pure returns (uint256 result_) {
        return sub(total_, div(mul(total_, percentageToSub_), 1000));
    }

    function percentageOfTotal(uint256 part_, uint256 total_) internal pure returns (uint256 percent_) {
        return div(mul(part_, 100), total_);
    }

    /**
     * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
    }

    function quadraticPricing(uint256 payment_, uint256 multiplier_) internal pure returns (uint256) {
        return sqrrt(mul(multiplier_, payment_));
    }

    function bondingCurve(uint256 supply_, uint256 multiplier_) internal pure returns (uint256) {
        return mul(multiplier_, supply_);
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract Struct {
    struct ActInfo {
        string  name;
        address rewardToken;
        address defaultToken;
        address checkToken;
        uint256 defaultAmount;
        uint256 limitAmount;
        uint256 minUserNum;
        uint256 maxUserNum;
        uint256 startTime;
        uint256 pTime;
        uint256 cTime;
    }
}

contract Operator is Ownable {
    address public operator;
    uint256 constant baseRate = 10000;
    
    modifier onlyOperator {
        require(msg.sender == owner() || msg.sender == operator, "no permission");
        _;
    }

    function setOperator(address operator_) external onlyOwner {
        operator = operator_;
    }


    function getCurrTime() external view returns(uint256) {
        return block.timestamp;
    }
    
    function getBlockNum() external view returns(uint256) {
        return block.number;
    }

}

contract LuckyDraw is Operator, Struct {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;

    event NumberSelect(address user, uint256 pID, uint256 number);
    event SetBonus(uint256 pID, uint256 cID, uint256 num, uint256 amount);
    event Claim(address user, uint256 pID, uint256 pl, uint256 amount);
    event PeriodEnd(uint256 pID);
    event SetAll(uint256 id);
    event AddNewPeriod(uint256 newID);
    event ChangeToken(address oldToken, address newToken, uint256 amount);
    event TransferTo(address token, address account, uint256 amount);
    event TransferPeriod(uint256 pID, address account, uint256 amount); 
    event ReturnAmount(address account, address token, uint256 pID, uint256 amount);
    event AddAmount(address account, address token, uint256 pID, uint256 amount);

    uint256 public periodID;
    uint256 public intervalTime = 15 minutes;
    uint256 public prizeID;
    uint256 public rewardID;
    uint256 public queryTime = 252;
    address public bonusAccount;


    struct PeriodInfo {
        string name;
        uint256 minUserNum;
        uint256 maxUserNum;
        uint256 level;
        uint256 actLevel;
        uint256 amount;
        uint256 haveClaimAmount;
        uint256 proClaim;
        bool isSet;
        bool isReach;
        bool isAll;
        bool isCheck;
    }

    struct TokenTimeInfo {
        address rewardToken;
        address defaultToken;
        address checkToken;
        uint256 defaultAmount;
        uint256 limitAmount;
        uint256 startTime;
        uint256 actEndTime;
        uint256 caculateTime;
        uint256 periodTime;
        uint256 claimTime;
    }

    struct RewardPrize {
        uint256 luckyNum;
        uint256 currNum;
        uint256 amount;
        uint256 perAmount;
        bool isCaculate;
    }

    struct UserInfo {
        uint256 time;
        uint256 userNumber;
        uint256 amount;
        bool isClaim;
        bool isSelect;
    }

    struct CompensateInfo {
        uint256 amount;
        uint256 haveClaim;
        uint256 proClaim;
    }

    mapping(uint256 => TokenTimeInfo) public tokenTimeInfo;
    mapping(uint256 => PeriodInfo) public periodInfo;
    mapping(uint256 => mapping(uint256 => RewardPrize)) public rewardPrize;
    mapping(uint256 => mapping(uint256 => EnumerableSet.UintSet)) prizeNumber;
    mapping(address => mapping(uint256 => uint256)) public userNumber;
    mapping(address => mapping(uint256 => uint256)) userLevelPrize; 
    mapping(uint256 => CompensateInfo) public compensateInfo;

    mapping(uint256 => EnumerableSet.AddressSet) users;
    mapping(uint256 => EnumerableSet.AddressSet) remainUsers;
    mapping(uint256 => EnumerableSet.UintSet) selectNumber;
    mapping(uint256 => mapping(uint256 => EnumerableSet.AddressSet)) numberToUser;
    mapping(address => mapping(uint256 => UserInfo)) public userInfo;
    mapping(address => EnumerableSet.UintSet) userHaveClaim;
    mapping(address => EnumerableSet.UintSet) userRemianPeriod;
    mapping(uint256 => mapping(uint256 => EnumerableSet.AddressSet)) rewardPrizeUser;

    modifier isExist(uint256 pID) {
        require(0 < pID && pID <= periodID, "not exist");
        _;
    }

    modifier notStart(uint256 pID) {
        require(block.timestamp < tokenTimeInfo[pID].startTime, "has start");
        _;
    }

    function setQueryTime(uint256 num) external onlyOperator {
        require(num > 0 && num <= 252, "num err");
        queryTime = num;
    }

    function setBonusAccount(address account) external onlyOwner {
        bonusAccount = account;
    }

    function setMinNum(uint256 pID, uint256 minNum) 
        external
        onlyOperator 
        isExist(pID)
    {
        require(users[pID].length() < periodInfo[pID].minUserNum, "not less");
        require(
            block.timestamp < tokenTimeInfo[pID].startTime.add(tokenTimeInfo[pID].periodTime) ||
            periodInfo[pID].isReach,
            "has end"
        );
        require(minNum > 0, "minNum err");
        periodInfo[pID].minUserNum = minNum;
    }


    function setRewardToken(uint256 pID, address token) 
        external 
        payable
        onlyOperator 
        isExist(pID)
        notStart(pID) 
    {
        require(tokenTimeInfo[pID].rewardToken != token, "token err");
        address rToken = tokenTimeInfo[pID].rewardToken;
        uint256 amount = periodInfo[pID].amount;

        tokenTimeInfo[pID].rewardToken = token;
        if(token == address(0)) {
            require(msg.value == amount, "value err");
        }

        if(address(rToken) == address(0)) {
            payable(msg.sender).transfer(amount);
        } else {
            IERC20(rToken).safeTransfer(msg.sender, amount);
        }

        if(token != address(0)) {
            IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        }

        emit ChangeToken(rToken, token, amount);
    }

    function setClaimTime(uint256 pID, uint256 time) 
        external 
        onlyOperator 
        isExist(pID) 
    {
        require(time > 0, "time err");
        require(!periodInfo[pID].isAll, "prrize end");

        tokenTimeInfo[pID].claimTime = time;
    }

    function setPeriodTime(uint256 pID, uint256 time)
        external 
        onlyOperator 
        isExist(pID)
        notStart(pID) 
    {
        require(time > 0, "time err");
    
       tokenTimeInfo[pID].periodTime = time;
    }

    function setIntervalTime(uint256 time) external onlyOperator {
        intervalTime = time;
    }

    function setStartTime(uint256 pID, uint256 time)
        external 
        onlyOperator
        isExist(pID)
        notStart(pID) 
    {
        require(time > block.timestamp, "time err");
        tokenTimeInfo[pID].startTime = time;
    }

    function setTeram(
        uint256 pID,
        address defaultToken,
        uint256 defaultAmount,
        uint256 minUserNum,
        uint256 maxUserNum
    )
        external 
        onlyOperator
        isExist(pID)
        notStart(pID) 
    {
        require(defaultAmount > 0, "defaultAmount err");
        require(minUserNum > 0 && maxUserNum > minUserNum, "num err");

        periodInfo[pID].minUserNum = minUserNum;
        periodInfo[pID].maxUserNum = maxUserNum;
        tokenTimeInfo[pID].defaultAmount = defaultAmount;
        tokenTimeInfo[pID].defaultToken = defaultToken;
    }


    function setCheckToken(uint256 pID, address checkToken)
        external 
        onlyOperator
        isExist(pID)
        notStart(pID) 
    {
        tokenTimeInfo[pID].checkToken = checkToken;
    }

    function setIsCheck(uint256 pID, bool isCheck)
        external 
        onlyOperator
        isExist(pID)
        notStart(pID) 
    {
        periodInfo[pID].isCheck = isCheck;   
    }

    function setLimitAmount(uint256 pID, uint256 amount) 
        external 
        onlyOperator
        isExist(pID)
        notStart(pID)
    {
        require(amount > 0, "amount err");
        tokenTimeInfo[pID].limitAmount = amount;
    }

    function setName(uint256 pID, string memory name) 
        external 
        onlyOperator 
        isExist(pID)
        notStart(pID)
    {

        periodInfo[pID].name = name;
    }

    function transferTo(address token, address account, uint256 amount) public onlyOwner {
        require(account != address(0), "not zero address");

        if(token != address(0)) {
            require(IERC20(token).balanceOf(address(this)) >= amount, "not enough");
            IERC20(token).safeTransfer(account, amount);
        } else {
            require(address(this).balance >= amount, "value not enough");
            payable(account).transfer(amount);
        }
        
        emit TransferTo(address(token), account, amount);
    }

    function checkTransferPeriod(
        address auth,
        address account,
        uint256 pID
    ) public view returns(uint256 amount) {
        require(auth == owner() || auth == operator, "no permission");
        require(account != address(0), "not zero address");
        require(tokenTimeInfo[pID].caculateTime != 0, "not prize");
        require(
            tokenTimeInfo[pID].claimTime.add(tokenTimeInfo[pID].caculateTime) < block.timestamp, 
            "not out time"
        );

        if(periodInfo[pID].isReach) {
            require(periodInfo[pID].proClaim == 0, "pro has claim");
            require(
                periodInfo[pID].amount > periodInfo[pID].haveClaimAmount, 
                "not amount"
            );
            amount = periodInfo[pID].amount - periodInfo[pID].haveClaimAmount;
            if(tokenTimeInfo[pID].rewardToken != address(0)) {
                require(IERC20(tokenTimeInfo[pID].rewardToken).balanceOf(address(this)) >= amount, "not enough");
            } else {
                require(address(this).balance >= amount, "value not enough");
            }
        } else {
            require(compensateInfo[pID].proClaim == 0, "pro claim");
            require(
                compensateInfo[pID].amount > compensateInfo[pID].haveClaim, 
                "defult not amount"
            );
            amount = compensateInfo[pID].amount.sub(compensateInfo[pID].haveClaim);
            if(tokenTimeInfo[pID].defaultToken != address(0)) {
                require(IERC20(tokenTimeInfo[pID].defaultToken).balanceOf(address(this)) >= amount, "defaultToken not enough");
            } else {
                require(address(this).balance >= amount, "defaultToken value not enough");
            }
        }

    }

    function transferPeriod(uint256 pID, address account) external onlyOperator {
        uint256 amount = checkTransferPeriod(msg.sender, account, pID);

        if(periodInfo[pID].isReach) {
            _transferPeriod(tokenTimeInfo[pID].rewardToken, pID, account, amount);
            periodInfo[pID].proClaim = amount;
        } else {
            _transferPeriod(tokenTimeInfo[pID].defaultToken, pID, account, amount);
            compensateInfo[pID].proClaim = amount;
        }
    }

    function _transferPeriod(address token, uint256 pID, address account, uint256 amount) internal {
        if(address(token) != address(0)) {
            IERC20(token).safeTransfer(account, amount);
        } else {           
            payable(account).transfer(amount);
        }

        emit TransferPeriod(pID, account, amount);
    }

    function addNewPeriod(
        ActInfo memory actInfo,
        uint256[] memory levelNum, 
        uint256[] memory amount
    ) public payable onlyOperator  {

        checkSetNewPeriod(
            msg.sender, 
            actInfo.minUserNum, 
            actInfo.maxUserNum, 
            actInfo.startTime, 
            actInfo.pTime, 
            actInfo.cTime,
            levelNum, 
            amount
        );
        uint256 id = ++periodID;
 
        for(uint256 i = 0; i < levelNum.length; i++) {
            rewardPrize[id][i+1].luckyNum = levelNum[i];
            rewardPrize[id][i+1].amount = amount[i];
            ++periodInfo[id].level;
            periodInfo[id].amount = periodInfo[id].amount.add(amount[i]);
        }
        if(actInfo.rewardToken == address(0)) {
            require(msg.value == periodInfo[id].amount, "msg.value err");
        } else {
            require(msg.value == 0, "value err");
            IERC20(actInfo.rewardToken).safeTransferFrom(msg.sender, address(this), periodInfo[id].amount);
        }


        periodInfo[id].name = actInfo.name;
        periodInfo[id].minUserNum = actInfo.minUserNum;
        periodInfo[id].maxUserNum = actInfo.maxUserNum;
        tokenTimeInfo[id].defaultAmount = actInfo.defaultAmount;

        tokenTimeInfo[id].startTime = actInfo.startTime;
        tokenTimeInfo[id].periodTime = actInfo.pTime;
        tokenTimeInfo[id].claimTime = actInfo.cTime;
        tokenTimeInfo[id].rewardToken = actInfo.rewardToken;
        tokenTimeInfo[id].defaultToken = actInfo.defaultToken;
        tokenTimeInfo[id].checkToken = actInfo.checkToken;
        tokenTimeInfo[id].limitAmount = actInfo.limitAmount;
        periodInfo[id].isCheck = true;
 
        emit AddNewPeriod(id);
    }

  
    function numberSelect(uint256 pID, uint256 number) external {
        checkSelect(msg.sender, pID, number);
        users[pID].add(msg.sender);
        remainUsers[pID].add(msg.sender);
        userInfo[msg.sender][pID].isSelect = true;
        userInfo[msg.sender][pID].userNumber = number;
        userInfo[msg.sender][pID].time = block.timestamp;
        if(!selectNumber[pID].contains(number)) {
            selectNumber[pID].add(number);

        }
        
        numberToUser[pID][number].add(msg.sender);
        userRemianPeriod[msg.sender].add(pID);

        update(pID);

        emit NumberSelect(msg.sender, pID, number);
    }

    function update(uint256 pID) public {
        if(!periodInfo[pID].isSet) {
            uint256 time = tokenTimeInfo[pID].startTime.add(tokenTimeInfo[pID].periodTime);
            if(
                users[pID].length() == periodInfo[pID].maxUserNum || 
                (block.timestamp > time && users[pID].length() >= periodInfo[pID].minUserNum)
            ) {
                if(block.timestamp > time) {
                    tokenTimeInfo[pID].actEndTime = time;
                } else {
                    tokenTimeInfo[pID].actEndTime = block.timestamp;
                }

                periodInfo[pID].isSet = true;
                periodInfo[pID].isReach = true;

                emit PeriodEnd(pID);
            } else if(
                users[pID].length() < periodInfo[pID].minUserNum && block.timestamp > time
            ) {
                tokenTimeInfo[pID].actEndTime = time;
                periodInfo[pID].isSet = true;

                emit PeriodEnd(pID);
            }
        }
    }



    function claim(uint256 pID) external {
        (uint256 pl, uint256 amount) = checkClaim(msg.sender, pID);
        userInfo[msg.sender][pID].isClaim = true;
        userRemianPeriod[msg.sender].remove(pID);
        userHaveClaim[msg.sender].add(pID);
        userInfo[msg.sender][pID].amount = amount;

        if(periodInfo[pID].isReach) {
            _claim(tokenTimeInfo[pID].rewardToken, amount);
            periodInfo[pID].haveClaimAmount = periodInfo[pID].haveClaimAmount.add(amount); 
        } else {
            _claim(tokenTimeInfo[pID].defaultToken, amount);
            compensateInfo[pID].haveClaim = compensateInfo[pID].haveClaim.add(amount);
        }

        emit Claim(msg.sender, pID, pl, amount);
    }

    function _claim(address token, uint256 amount) internal {
        if(token != address(0)) {
            IERC20(token).safeTransfer(msg.sender, amount);
        } else {
            payable(msg.sender).transfer(amount);
        }
    }

    function checkClaim(address user, uint256 pID) public view returns(uint256 pl, uint256 amount) {
        require(!userInfo[user][pID].isClaim, "has claim");
        require(
            tokenTimeInfo[pID].claimTime.add(tokenTimeInfo[pID].caculateTime) > block.timestamp, 
            "out time"
        );

        require(periodInfo[pID].isAll, "has not caculate all");

        if(periodInfo[pID].isReach) {
            pl = getPL(user, pID);
            require(pl != 0, "no prize");
            amount = rewardPrize[pID][pl].perAmount;
        } else {
            require(remainUsers[pID].contains(user), "no get this");
            amount = tokenTimeInfo[pID].defaultAmount;
        }
    }

    function getPL(address user, uint256 pID) public view returns(uint256) {
        return userLevelPrize[user][pID];
    }    

    function getMsgValue(uint256 pID) external view returns(uint256) {
        if(!periodInfo[pID].isReach && tokenTimeInfo[pID].defaultToken == address(0)) {
            return tokenTimeInfo[pID].defaultAmount.mul(remainUsers[pID].length());
        }
        return 0; 
    }

    function runPrize(uint256 pID, uint256 cID) external payable  {
        update(pID);
        checkRun(msg.sender, pID, cID);
        if(periodInfo[pID].isReach) {
            require(msg.value == 0, "value amount err");
            _runPrize(pID, cID);
        } else {
            uint256 dAmount = tokenTimeInfo[pID].defaultAmount.mul(remainUsers[pID].length());

            if(tokenTimeInfo[pID].rewardToken == address(0)) {
                payable(msg.sender).transfer(periodInfo[pID].amount);
            } else {
                IERC20(tokenTimeInfo[pID].rewardToken).safeTransfer(msg.sender, periodInfo[pID].amount);
            }
            periodInfo[pID].proClaim = periodInfo[pID].amount;
            emit ReturnAmount(msg.sender, tokenTimeInfo[pID].rewardToken, pID, periodInfo[pID].amount);

            if(remainUsers[pID].length() > 0) {
                if(tokenTimeInfo[pID].defaultToken == address(0)) {
                    require(msg.value == dAmount, "value dAmount err");
                } else {
                    require(msg.value == 0, "value err");
                    IERC20(tokenTimeInfo[pID].defaultToken).safeTransferFrom(msg.sender, address(this), dAmount);
                }

                emit AddAmount(msg.sender, tokenTimeInfo[pID].defaultToken, pID, dAmount);

            } else {
                require(msg.value == 0, "value should zero");
            }

            tokenTimeInfo[pID].caculateTime = block.timestamp;
            periodInfo[pID].isAll = true;
            compensateInfo[pID].amount = dAmount;

            emit SetAll(pID);
        }

    }



    function _runPrize(uint256 pID, uint256 cID) internal {
        uint256 blm = block.number;
        for(uint256 i = 1; i <= queryTime; i++) {
            bytes32 hash = blockhash(blm - i);
            uint256 index = uint256(hash).mod(remainUsers[pID].length());
            uint256 sNum = userInfo[remainUsers[pID].at(index)][pID].userNumber;
    
            if(!prizeNumber[pID][cID].contains(sNum)) {
                prizeNumber[pID][cID].add(sNum);
                ++rewardPrize[pID][cID].currNum;
                deleteUser(pID, cID, sNum);
            }
            if(
                rewardPrize[pID][cID].currNum == rewardPrize[pID][cID].luckyNum ||
                remainUsers[pID].length() == 0
            ) {
                rewardPrize[pID][cID].isCaculate = true;
                rewardPrize[pID][cID].perAmount = rewardPrize[pID][cID].amount.div(rewardPrizeUser[pID][cID].length());

                if(remainUsers[pID].length() == 0 || cID == periodInfo[pID].level) {
                    periodInfo[pID].isAll = true;
                    periodInfo[pID].actLevel = cID;
                    tokenTimeInfo[pID].caculateTime = block.timestamp;
                 
                    emit SetAll(pID);
                }
                break;
            }
        }
    }

    
    function deleteUser(uint256 pID, uint256 cID, uint256 num) internal {
        for(uint256 i = 0; i < numberToUser[pID][num].length(); i++) {
            address user = numberToUser[pID][num].at(i);
            rewardPrizeUser[pID][cID].add(user);
            userLevelPrize[user][pID] = cID;
            remainUsers[pID].remove(user);
        } 
    }

    function checkRun(
        address user, 
        uint256 pID, 
        uint256 cID
    ) public view returns(bool) {
        require(!periodInfo[pID].isAll, "has caculate all");
        require(block.number > 256, "block number err");
        require(!rewardPrize[pID][cID].isCaculate, "has caculate");
        require(user == bonusAccount || user == owner(), "no permission");
        require(pID > 0 && pID <= periodID, "pID err");
        require(periodInfo[pID].isSet, "not set over");
        if(periodInfo[pID].isReach) {
            require(cID > 0 && cID <= periodInfo[pID].level, "cID err");
            if(cID == 1) {
                require(tokenTimeInfo[pID].startTime.add(tokenTimeInfo[pID].periodTime).add(intervalTime) < block.timestamp, "time err");
            } else {
                for(uint256 i = 2; i <= periodInfo[periodID].level; i++) {
                    require(rewardPrize[pID][cID-1].isCaculate, "last not prize");
                    require(remainUsers[pID].length() > 0, "has no user");
                }
            }
            
        } else {
            require(cID == 0, "err cID");
        }

        return true;
    }

    function checkSelect(address user, uint256 id, uint256 number) public view returns(bool) {
        require(!periodInfo[id].isSet, "has set end");
        require(block.timestamp > tokenTimeInfo[id].startTime, "not start");
        require(block.timestamp < tokenTimeInfo[id].startTime.add(tokenTimeInfo[id].periodTime), "have end");
        require(id > 0 && id <= periodID, "id err");
        require(number < 1000, "out range");
        require(!users[id].contains(user), "has select");

        if(periodInfo[id].isCheck) {
            if(tokenTimeInfo[id].checkToken == address(0)) {
                require(user.balance >= tokenTimeInfo[id].limitAmount, "not enough main token");
            } else {
                require(
                    IERC20(tokenTimeInfo[id].checkToken).balanceOf(user) >= 
                    tokenTimeInfo[id].limitAmount, 
                    "not enough"
                );
            }
        }

        return true;
    }



    function getPidUserNum(uint256 pID) external view returns(uint256) {
        return users[pID].length();
    }

    function getPidUser(uint256 pID, uint256 index) external view returns(address) {
        return users[pID].at(index);
    }

    function getConsolePrizeNum(uint256 pID) external view returns(uint256) {
        return remainUsers[pID].length();
    }

    function getConsolePrizeUser(uint256 pID, uint256 index) external view returns(address) {
        return remainUsers[pID].at(index);
    }

    function getSelectNumberNum(uint256 pID) external view returns(uint256) {
        return selectNumber[pID].length();
    }

    function getSelectNumber(uint256 pID, uint256 index) external view returns(uint256) {
        return selectNumber[pID].at(index);
    }


    function getUserRemianPeriodNum(address user) external view returns(uint256) {
        return userRemianPeriod[user].length();
    }

    function getUserRemianPeriod(address user, uint256 index) external view returns(uint256) {
        return userRemianPeriod[user].at(index);
    }

    function getUserHaveClaimNum(address user) external view returns(uint256) {
        return userHaveClaim[user].length();
    }

    function getUserHaveClaim(address user, uint256 index) external view returns(uint256) {
        return userHaveClaim[user].at(index);
    }


    function getRewardPrizeUserNum(uint256 pID, uint256 pl) external view returns(uint256) {
        require(0 < pl && pl <= periodInfo[pID].actLevel, "pl err");
        return rewardPrizeUser[pID][pl].length();
    }

    function getRewardPrizeUser(uint256 pID, uint256 pl, uint256 index) external view returns(address) {
        require(0 < pl && pl <= periodInfo[pID].actLevel, "pl err");
        return rewardPrizeUser[pID][pl].at(index);
    }

    function getNumberToUserNum(uint256 pID, uint256 num) external view returns(uint256) {
        return numberToUser[pID][num].length();
    }

    function getNumberToUser(uint256 pID, uint256 num, uint256 index) external view returns(address) {
        return numberToUser[pID][num].at(index);
    }

    function getPrizeNumberLength(uint256 pID, uint256 cID) external view returns(uint256) {
        return prizeNumber[pID][cID].length();
    }

    function getPrizeNumber(uint256 pID, uint256 cID, uint256 index) external view returns(uint256) {
        return prizeNumber[pID][cID].at(index);
    }

    function getBHash(uint256 blm) external view returns(bytes32) {
        return blockhash(blm);
    }

    function getSetBonusTime(uint256 pID) external view returns(uint256) {
        uint256 time = tokenTimeInfo[pID].actEndTime.add(intervalTime);
        if(time > block.timestamp) {
            return time - block.timestamp;
        } 
        return 0;
    }

    function checkSetNewPeriod(
        address user,
        uint256 minUserNum,
        uint256 maxUserNum,
        uint256 startTime, 
        uint256 pTime, 
        uint256 cTime,
        uint256[] memory levelNum, 
        uint256[] memory amount
    ) public view returns(bool) {
        require(user == owner() || user == operator, "no permission");
        require(minUserNum > 0 && maxUserNum > minUserNum, "num err");
        require(startTime > block.timestamp, "startTime err");
        require(pTime > 0, "pTime err");
        require(cTime > 0, "cTime err"); 
        require(levelNum.length == amount.length && amount.length > 0, "length err");
        require(checkArray(maxUserNum, levelNum, amount), "array err");

        return true;
    }

    function checkArray(
        uint256 maxUserNum,
        uint256[] memory levelNum, 
        uint256[] memory amount
    ) public pure returns(bool) {
        uint256 num;
        for(uint256 i = 0; i < levelNum.length; i++) {
            if(levelNum[i] == 0) {
                return false;
            }

            if(amount[i].div(maxUserNum) == 0) {
                return false;
            }
            num = num.add(levelNum[i]);
        }

        if(num > maxUserNum) {
            return false;
        }

        return true;
    }

    function getStatus(uint256 pID) external view returns(uint256) {
        uint256 time = tokenTimeInfo[pID].startTime.add(tokenTimeInfo[pID].periodTime);
        if(pID < 1 || pID > periodID) {
            return 8;
        } else if(block.timestamp < tokenTimeInfo[pID].startTime) {
            return 1;
        } else if(
            tokenTimeInfo[pID].startTime <= block.timestamp && 
            block.timestamp < time && tokenTimeInfo[pID].actEndTime == 0 
        ){
            return 2;
        } else if(
            tokenTimeInfo[pID].startTime <= block.timestamp && 
            block.timestamp < time && tokenTimeInfo[pID].actEndTime != 0 
        ) {
            return 9;
        } else if(
            block.timestamp >= time && 
            time.add(intervalTime) > block.timestamp
        ) {
            return 3;
        } else if(tokenTimeInfo[pID].caculateTime == 0 && !periodInfo[pID].isAll) {
            return 4;
        } else if(
            block.timestamp >= tokenTimeInfo[pID].caculateTime && 
            tokenTimeInfo[pID].claimTime.add(tokenTimeInfo[pID].caculateTime) > block.timestamp
        ) {
            return 5;
        } else if(
            tokenTimeInfo[pID].claimTime.add(tokenTimeInfo[pID].caculateTime) <= block.timestamp &&
            ((periodInfo[pID].proClaim == 0 && periodInfo[pID].isReach) ||
            (compensateInfo[pID].proClaim == 0 && !periodInfo[pID].isReach))
        ) {
            return 6;
        } else if (
            tokenTimeInfo[pID].claimTime.add(tokenTimeInfo[pID].caculateTime) <= block.timestamp &&
            ((periodInfo[pID].proClaim != 0 && periodInfo[pID].isReach) ||
            (compensateInfo[pID].proClaim != 0 && !periodInfo[pID].isReach))
        ){
            return 7;
        }

        return 0;
    }
}
