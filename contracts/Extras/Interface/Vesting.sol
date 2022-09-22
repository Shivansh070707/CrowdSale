// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
import "./IERC20.sol";
interface IVest{
  event Released(uint256 amount);
  event Revoked();
   function release(IERC20 token) external returns (bool);
   function revoke(IERC20 token) external returns(bool);
   function releasableAmount(IERC20 token) external view returns (uint256);
  function vestedAmount(IERC20 token) external view returns (uint256);
   function token() external view returns (IERC20);
    function releaseTime(uint256 _vestingId) external view returns (uint256);
   function beneficiary(uint256 _vestingId) external view returns (address);
   function vestingAmount(uint256 _vestingId) external view returns (uint256);
    function removeVesting(uint256 _vestingId) external;
    function addVesting(uint _startTime, uint256 _releaseTime, uint256 _amount) external;
    function release(uint256 _vestingId) external;
            
    function retrieveExcessTokens(uint256 _amount) external;
}