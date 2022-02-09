// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
pragma solidity >=0.4.21;
pragma experimental ABIEncoderV2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/finance/PaymentSplitter.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/utils/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";





// Create owner of the will
contract cryptoWill {
    event setOwnerData( uint date, address indexed from );
    event setBeneficiaryToWill( uint date, address indexed from );
    event UpdateBeneficiaryShare( uint date, address indexed from );
    event UpdateBeneficiaryWallet( uint date, address indexed from );
    event setBeneficiaryData( uint date, address indexed from );
    
    using SafeMath for uint;



    // Will index initialization
    uint256 _sharesRemaing=100;

    // mapping as struct so that it can be returned back
    struct willMap{
        uint256 willNum;
        // Create collection on wills        
        mapping(uint256 => owner_of_the_will) wills;
    }
    willMap internal allWills;

    // Struct for owner of the will data
    struct owner_of_the_will{
        string o_firstName;
        string o_lastName;
        string o_ssn;
        string o_dob;
        address o_wallet_address;
        beneficiary[] beneficiaries;
        address execWallet; // this is person who will assert death
        string execKey; // this is secret phrase to be able to assert death
        bool o_pol; // proof of life to be set to true when setting up the will
    }

    // Struct of the Beneficiaries data 
    struct beneficiary{
        string b_firstName;
        string b_lastName;
        string b_ssn;
        string b_dob;
        uint b_share;
        address payable b_wallet_address;
    }
    // Create a list of beneficiaries to add to the will 
    beneficiary[] public beneficiariesOfWill;
    
    // Create the owner struct variable
    owner_of_the_will public wOwner;
    
    // declare the will owner's address variable as a state variable
    address public willOwner;

    // this modifier will make sure that only Owner of the will will have access to the functions
    modifier onlyOwner {
        require(msg.sender == willOwner, "You do not have permission to make changes!");
    _;
    }
    // constructor for the owner contract
    constructor() payable {
        willOwner = msg.sender;
    }


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
                          address _walletAddress,
                          address _execWallet,
                          string memory _execKey
                          ) public  
    {
      //owner_of_the_will owner;
        wOwner.o_firstName = _firstName;
        wOwner.o_lastName = _lastName;
        wOwner.o_ssn = _ssn;
        wOwner.o_dob = _dob;
        wOwner.o_wallet_address = _walletAddress;
        wOwner.execWallet = _execWallet;
        wOwner.execKey = _execKey;
        wOwner.o_pol = true;
        // Increment the willId for this will
        uint256 willId = allWills.willNum++;
        
        // Create the mappping of willNum to the wills
        allWills.wills[willId] = wOwner;
        
        //log the transaction
        emit setOwnerData(block.timestamp, msg.sender );
    }
       
    // Get owner data
    function getWillData(uint _willId, address _owalletAddress) internal view returns(owner_of_the_will storage )
    {
        require(_owalletAddress == allWills.wills[_willId].o_wallet_address, "You are not Authorized to access this account");
        return(allWills.wills[_willId]);
    }

    // Use this public function to call the Internal function to get the the will
    function getWill(uint _willId, address _owalletAddress) public view returns (owner_of_the_will memory){
        return(getWillData(_willId, _owalletAddress));}

    // This function set the values passed to it in the state variables for the beneficiarOfWill  
    function setBeneficiarydata(string memory _firstName, 
                                string memory _lastName, 
                                string memory _ssn, 
                                string memory _dob, 
                                uint _share, 
                                address payable _walletAddress) internal 
    {
        beneficiary memory _beneficiaries;
        // check if there are enough shares to be allocated to the new beneficiary
        //if (_sharesRemaing >= _share)
        _beneficiaries.b_firstName = _firstName;
        _beneficiaries.b_lastName = _lastName;
        _beneficiaries.b_ssn = _ssn;
        _beneficiaries.b_dob = _dob;
        _beneficiaries.b_share = _share;
        _beneficiaries.b_wallet_address = _walletAddress;
        beneficiariesOfWill.push(_beneficiaries);
        //_sharesRemaing -= _share;
        emit setBeneficiaryData(block.timestamp, msg.sender );
    }

    // Use this public function to call the Internal function to set the beneficiaries in the will
    function setBeneCallInternalFunc(string memory _fname, 
                                     string memory _lname, 
                                     string memory _ssn, 
                                     string memory _dob, 
                                     uint _share, 
                                     address payable _walletAddress) public{
        setBeneficiarydata(_fname, _lname, _ssn,  _dob, _share, _walletAddress) ;
    }    

   
    // update will beneficiaries once all the beneficiaries are added to the array
    function setBeneficiaries_in_will(uint256 _willId) internal {
        willMap storage will = allWills;
        will.wills[_willId].beneficiaries = beneficiariesOfWill;
        delete beneficiariesOfWill;
    }
    // This function clears out the array of beneficiaries for the next will
    function removebeneficiariesOfWill() public
        {
            for(uint i; i<beneficiariesOfWill.length-1; i++){
                beneficiariesOfWill.pop();

            }
        }

    // Use this public function to call the Internal function to set the beneficiaries in the will
    function setBeneInternalFuncCall(uint256 _willId) public {
        setBeneficiaries_in_will(_willId);
     }    
     // This function is called when the owner of the will is deceased and the executor of the will asserts that the person has indeed died
     // this will also distribute the assets according to the will to heirs
    function assertDeath(address _execwallet, string memory _execKey, uint256 _willId, address _ownerWallet) public returns(beneficiary[] memory) { 
        // Validate executor identity , uint256 _assetBalance
        require(allWills.wills[_willId].o_pol == true, "Person already deceased and the Will has been Executed"); // Check for Proof Of life
        require(_ownerWallet == allWills.wills[_willId].o_wallet_address, "You are not Authorized to access this account");
        require(compareTwoStrings(_execKey, allWills.wills[_willId].execKey), "You are not Authorized to access this account");
        require(_execwallet == allWills.wills[_willId].execWallet, "You are not Authorized to access this account");
        
        // Check if there are any payees in the will
        require(allWills.wills[_willId].beneficiaries.length > 0, "PaymentSplitter: no payees");
        
       allWills.wills[_willId].o_pol = false;
       return (allWills.wills[_willId].beneficiaries);
    }

     // compares two strings
    function compareTwoStrings(string memory string1, string memory string2) public pure returns (bool)
    {
        return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
    }

    // get all beneficiaries
    function getBeneficiaries(uint256 _willId, string memory _bssn) public view returns (string memory _fname, 
                                     string memory _lname, 
                                     string memory _ssn, 
                                     string memory _dob, 
                                     uint _share, 
                                     address _walletAddress){
        for(uint256 i=0; i < allWills.wills[_willId].beneficiaries.length; i++){
            if(compareTwoStrings(allWills.wills[_willId].beneficiaries[i].b_ssn, _bssn)){
                return(allWills.wills[_willId].beneficiaries[i].b_firstName,
                allWills.wills[_willId].beneficiaries[i].b_lastName,
                allWills.wills[_willId].beneficiaries[i].b_ssn,
                allWills.wills[_willId].beneficiaries[i].b_dob,
                allWills.wills[_willId].beneficiaries[i].b_share,
                allWills.wills[_willId].beneficiaries[i].b_wallet_address);
            }
        }        
    }


 /*   
     //Code below is for future use NOT ALL is working
    // get all beneficiaries
   function getAllBeneficiaries(uint256 _willId, string memory _ossn) public view returns(beneficiary[] memory)
   {
        for(uint256 i; i < allWills.wills[_willId].beneficiaries.length; i++)
        {
            if(compareTwoStrings(allWills.wills[_willId].o_ssn, _ossn))
            {
                return(allWills.wills[_willId].beneficiaries);
            }
        }
   }

  // update will owner's wallet address
    function updateOwnersWalletAddress(address _walletAddress) internal onlyOwner{
        owner_of_the_will storage newOwner = wOwner;
        newOwner.o_wallet_address = _walletAddress;
        emit setBeneficiaryToWill(block.timestamp, msg.sender );

    }
 
  // Update a beneficiary's share
    function updateBeneficiaryShare(string memory _ssn, uint _share) public  onlyOwner returns(bool){
        beneficiary[] storage newBenef = beneficiariesOfWill;
        for (uint i=0; i < newBenef.length; i++)
        {
            if(compareTwoStrings(newBenef[i].b_ssn, _ssn))
            {
                newBenef[i].b_share = _share;
                emit UpdateBeneficiaryShare(block.timestamp, msg.sender);
                return true;
            }
        }
        return false;
    }
    
    // Let beneficiary update their wallet address
    function updateBeneficiaryWallet(string memory _ssn, address payable _walletAddress) public onlyOwner returns(bool) {
        beneficiary[] storage newBenef = beneficiariesOfWill;
        for (uint i=0; i < newBenef.length; i++)
        {
            if(compareTwoStrings(newBenef[i].b_ssn, _ssn))
            {
                newBenef[i].b_wallet_address = _walletAddress;
                emit UpdateBeneficiaryWallet(block.timestamp, msg.sender);
                return true;
            }
        }
        return false;
    }*/

}