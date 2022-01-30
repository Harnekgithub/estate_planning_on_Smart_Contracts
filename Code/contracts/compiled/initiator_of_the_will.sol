pragma solidity <=0.5.17;

import "./will.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

 
contract owner {
    struct owner_of_the_will{
        string o_firstName;
        string o_lastName;
        string o_ssn;
        string o_dob;
        address o_wallet_address;
    }
    owner_of_the_will public owner;
    address addressOwner;
    constructor(string memory _firstName, string memory _lastName, string memory _ssn, string memory _dob, address _walletAddress) public{
        
      //owner_of_the_will owner;
        owner.o_firstName = _firstName;
        owner.o_lastName = _lastName;
        owner.o_ssn = _ssn;
        owner.o_dob = _dob;
        owner.o_wallet_address = _walletAddress;
        addressOwner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == addressOwner, "You do not have permission to mint these tokens!");
    _;
    }
    function modifyownerWalletAddress(address _walletAddress) public onlyOwner{
        owner_of_the_will storage newOwner = owner;
        newOwner.o_wallet_address = _walletAddress;

    }

}
/*
contract beneficiaries{
  struct beneficary{
        string e_firstName;
        string e_lastName;
        string e_ssn;
        string p_dob;
        address payable e_wallet_address;
    }
}*/