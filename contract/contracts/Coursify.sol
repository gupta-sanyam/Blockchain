// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Coursify is ERC20 {
    
    address payable deployer;
    constructor() ERC20("Coursify", "CFY") {
        _mint(msg.sender, 10000 * 10 ** decimals());
        deployer = payable(msg.sender);
    }

    function airdrop(address payable to, uint amount) public {
        uint tot_amount = amount * 10 ** decimals();
        _transfer(deployer, to, tot_amount);
    }

    function get_balance(address of_account) public view returns(uint truncated_balance){
        uint amount = balanceOf(of_account);
        truncated_balance = amount/(10**decimals());
    }

    function approve_account(address spender, uint amount) public{
        approve(spender, amount*10**decimals());
    }
}