// SPDX-License-Identifier: UNLICENSED

pragma solidity <=0.7.4;

contract Oracle{
    
    uint256 public BTC;
    uint256 public ETH;
    uint256 public DOT;
    uint256 public LINK;
    uint256 public XRP;
    uint256 public YFI;
    uint256 public CORE;
    uint256 public BNB;
    uint256 public UNI;
    uint256 public USDT;
    
    
    address public owner;
    
    constructor(){
        owner = msg.sender;
    }
    
    function updateBtc(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        BTC = price;
    }
    
    function updateEth(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        ETH = price;
    }
    
    function updateXrp(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        XRP = price;
    }
    
    function updateDot(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        DOT = price;
    }
    
    function updateLink(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        LINK = price;
    }
    
    function updateYfi(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        YFI = price;
    }
    
    function updateCore(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        CORE = price;
    }
    
    function updateBnb(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        BNB = price;
    }
    
    function updateUni(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        UNI = price;
    }
    
    function updateUsdt(uint256 price) public {
        require(msg.sender==owner,'Cannot do this');
        USDT = price;
    }
    
}