// SPDX-License-Identifier: UNLICENSED

pragma solidity <=0.7.5;

import './bundle_token.sol';

contract Bundles {
    
    uint256 public bundleId = 1;
    address public owner;
    TokenMintERC20Token public bundle_address;
    
    uint256 public lastcreated;

    struct UserBets{
        uint256[10] bundles;
        uint256[10] prices;
    }
    
    struct User{
        uint256[] bundles;
        string username;
        uint256 balance;
        uint256 freebal;
        bool active;
    }
    
    struct Bundle{
        uint256[10] prices;
        uint256 startime;
        uint256 stakingends;
        uint256 endtime;
    }
    
    mapping(address => mapping(uint256 => UserBets)) bets;
    mapping(uint256 => Bundle) bundle;
    mapping(address => User) user;
    
    constructor(address _bundle_address) public{
        owner = msg.sender;
        bundle_address = TokenMintERC20Token(_bundle_address);
    }
    
    function Register(string memory _username) public returns(bool){
        User storage us = user[msg.sender];
        require(us.active == false,'Existing User');
        us.active = true;
        us.username = _username;
        return true;
    }
    
    function PlaceBet(uint256 index,uint256 _prices,uint256 _percent,uint256 _bundleId,uint256 _amount) public returns(bool) {
        require(_bundleId <= bundleId,'Invalid Bundle');
        require(bundle_address.allowance(msg.sender,address(this))>=_amount,'Approval failed');
        Bundle storage b = bundle[_bundleId];
        require(b.stakingends >= block.timestamp,'Ended');
        User storage us = user[msg.sender];
        require(us.active == true,'Register to participate');
        UserBets storage u = bets[msg.sender][_bundleId];
        us.bundles.push(_bundleId);
        us.balance = SafeMath.add(us.balance,_amount);
        u.bundles[index] = _percent; 
        u.prices[index] = _prices; 
        bundle_address.transferFrom(msg.sender,address(this),_amount);
        return true;
    }
    
    
    function updatebal(address _user,uint256 _reward,bool _isPositive) public returns(bool){
        require(msg.sender == owner,'Not Owner');
        require(_reward <=120,'Invalid Reward Percent');
        User storage us = user[_user];
        require(us.active == true,'Invalid User');
        uint256 a = SafeMath.mul(us.balance,_reward);
        uint256 b = SafeMath.div(a,10**2);
        if(_isPositive == true){
            uint256 c = SafeMath.add(us.balance,b);
            us.freebal = SafeMath.add(us.freebal,c);
        }
        else{
            uint256 c = SafeMath.sub(us.balance,b);
            us.freebal = SafeMath.add(us.freebal,c);
        }
        us.balance = 0;
        return true;
    }
    
    function createBundle(uint256[10] memory _prices) public returns(bool){
        require(msg.sender == owner,'Not Owner');
        require( block.timestamp > lastcreated + 7 days,'Cannot Create');
        Bundle storage b = bundle[bundleId];
        b.prices = _prices;
        b.startime = block.timestamp;
        lastcreated = block.timestamp;
        b.endtime = SafeMath.add(block.timestamp,7 days);
        b.stakingends = SafeMath.add(block.timestamp,1 days);
        bundleId = SafeMath.add(bundleId,1);
        return true;
    }
    
    function updateowner(address new_owner) public returns(bool){
        require(msg.sender == owner,'Not an Owner');
        owner = new_owner;
        return true;
    }
    
    function withdraw() public returns(bool){
       User storage us = user[msg.sender];
       require(us.active == true,'Invalid User'); 
       require(us.freebal > 0,'No bal');
       bundle_address.transfer(msg.sender,us.freebal);
       us.freebal = 0;
       return true;
    }
    
    function fetchUser(address _user) public view returns(uint256[] memory _bundles,string memory username,uint256 claimable,uint256 staked_balance, bool active){
        User storage us = user[_user];
        return(us.bundles,us.username,us.freebal,us.balance,us.active);
    }
    
    function fetchBundle(uint256 _bundleId) public view returns(uint256[10] memory _prices,uint256 _start,uint256 _end,uint256 _staking_ends){
        Bundle storage b = bundle[_bundleId];
        return(b.prices,b.startime,b.endtime,b.stakingends);
    }
    
    function fetchUserBets(address _user, uint256 _bundleId) public view returns(uint256[10] memory _bundles,uint256[10] memory _prices){
        UserBets storage u = bets[_user][_bundleId];
        return (u.bundles,u.prices);
    }
    
    function drain() public returns(bool,uint256){
        require(msg.sender == owner,'Not Owner');
        uint256 amount = bundle_address.balanceOf(address(this));
        bundle_address.transfer(msg.sender,amount);
        return(true,amount);
    }
    
}