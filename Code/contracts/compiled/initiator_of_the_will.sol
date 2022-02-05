// SPDX-License-Identifier: MIT
pragma solidity >=0.5.17;
pragma experimental ABIEncoderV2;
// import "./will.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/math/SafeMath.sol";

// compare two strings
/*library StrLib {
  function compareTwoStrings(string memory string1, string memory string2) public pure returns (bool)
  {
    return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
  }
}*/
// Create owner of the will
contract owner {
    // Struct to contain the data of the owner of the will
    struct owner_of_the_will{
        string o_firstName;
        string o_lastName;
        string o_ssn;
        string o_dob;
        address o_wallet_address;
        beneficiary[] beneficiaries;
    }
    // Struct to contain the data of the owner of the Beneficiaries
    struct beneficiary{
        string b_firstName;
        string b_lastName;
        string b_ssn;
        string b_dob;
        uint b_share;
        address b_wallet_address;
    }
    // Create a list of beneficiaries to add to the will 
    beneficiary[] public beneficiariesOfWill;
        

    // Create the owner struct variable
    owner_of_the_will internal wOwner;
    
    // declare the will owner's address variable as a state variable
    address willOwner;

    // this modifier will make sure that only Owner of the will will have access to the functions
    modifier onlyOwner {
        require(msg.sender == willOwner, "You do not have permission to make changes!");
    _;
    }
    // constructor for the owner contract
    constructor() { willOwner = msg.sender;  } 

    // Get owner data
    function getOwner() public view returns( address )
    {
        return(willOwner);
    }
    
    // This function set the values passed to it in the state variables for the owner    
    function setOwnerdata(string memory _firstName, 
                          string memory _lastName, 
                          string memory _ssn, 
                          string memory _dob, 
                          address _walletAddress) public  
    {
      //owner_of_the_will owner;
        wOwner.o_firstName = _firstName;
        wOwner.o_lastName = _lastName;
        wOwner.o_ssn = _ssn;
        wOwner.o_dob = _dob;
        wOwner.o_wallet_address = _walletAddress;

    }
       
    // Get owner data
    function getOwnerData() public view returns(owner_of_the_will memory )
    {
        return(wOwner);
    }


    // This function set the values passed to it in the state variables for the beneficiarOfWill  
    function setBeneficiarydata(string memory _firstName, 
                                string memory _lastName, 
                                string memory _ssn, 
                                string memory _dob, 
                                uint _share, 
                                address _walletAddress) internal 
    {
        beneficiary memory _beneficiaries;
        _beneficiaries.b_firstName = _firstName;
        _beneficiaries.b_lastName = _lastName;
        _beneficiaries.b_ssn = _ssn;
        _beneficiaries.b_dob = _dob;
        _beneficiaries.b_share = _share;
        _beneficiaries.b_wallet_address = _walletAddress;
        beneficiariesOfWill.push(_beneficiaries);
    }

    // Use this public function to call the Internal function to set the beneficiaries in the will
    function setBeneCallInternalFunc(string memory _fname, 
                                     string memory _lname, 
                                     string memory _ssn, 
                                     string memory _dob, 
                                     uint _share, 
                                     address _walletAddress) public{
        setBeneficiarydata(_fname, _lname, _ssn,  _dob, _share, _walletAddress) ;
    }    

    // update will owner's wallet address
    function updateOwnersWalletAddress(address _walletAddress) internal onlyOwner{
        owner_of_the_will storage newOwner = wOwner;
        newOwner.o_wallet_address = _walletAddress;

    }
    // update will beneficiaries once all the beneficiaries are added to the array
    function setBeneficiaries_in_wil() internal onlyOwner{
        owner_of_the_will storage newOwner = wOwner;
        newOwner.beneficiaries = beneficiariesOfWill;
    }
    // Use this public function to call the Internal function to set the beneficiaries in the will
    function setBeneInternalFuncCall() public{
        setBeneficiaries_in_wil();
    }    
    // get all beneficiaries
    function getBeneficiaries() public view returns(beneficiary[] memory){
        return(beneficiariesOfWill);
    }
    // Update a beneficiary's share
    function updateBeneficiaryShare(string memory _ssn, uint _share) public  onlyOwner returns(bool){
        beneficiary[] storage newBenef = beneficiariesOfWill;
        for (uint i=0; i < newBenef.length; i++)
        {
            if(compareTwoStrings(newBenef[i].b_ssn, _ssn))
            {
                newBenef[i].b_share = _share;
                return true;
            }
        }
        return false;
    }
    
    // Let beneficiary update their wallet address
    function updateBeneficiaryWallet(string memory _ssn, address _walletAddress) public onlyOwner returns(bool) {
        beneficiary[] storage newBenef = beneficiariesOfWill;
        for (uint i=0; i < newBenef.length; i++)
        {
            if(compareTwoStrings(newBenef[i].b_ssn, _ssn))
            {
                newBenef[i].b_wallet_address = _walletAddress;
                return true;
            }
        }
        return false;
    }

    // compares two strings
    function compareTwoStrings(string memory string1, string memory string2) public pure returns (bool)
    {
        return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
    }
}
