// SPDX-License-Identifier: MIT
pragma solidity >=0.5.17;
pragma experimental ABIEncoderV2;
// import "./will.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/math/SafeMath.sol";


// Create owner of the will
contract owner {
    event setOwnerData( uint date, address indexed from );
    event setBeneficiaryToWill( uint date, address indexed from );
    event UpdateBeneficiaryShare( uint date, address indexed from );
    event UpdateBeneficiaryWallet( uint date, address indexed from );
    event setBeneficiaryData( uint date, address indexed from );

    // Will index initialization
    //uint256 willId=0;
    // mapping as struct so that it can be returned back

    struct willMap{
        uint256 numOfWills;
        // Create collection on wills        
        mapping(uint256 => owner_of_the_will) wills;
    }
    willMap internal allWills;

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
    owner_of_the_will public wOwner;
    
    // declare the will owner's address variable as a state variable
    address willOwner;

    // this modifier will make sure that only Owner of the will will have access to the functions
    modifier onlyOwner {
        require(msg.sender == willOwner, "You do not have permission to make changes!");
    _;
    }
    // constructor for the owner contract
    constructor() public { willOwner = msg.sender;  } 

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

        // Increment the willId for this will
        uint256 willId = allWills.numOfWills++;
        
        // Create the mappping of numOfWills to the wills
        allWills.wills[willId] = wOwner;
        
        //log the transaction
        emit setOwnerData(block.timestamp, msg.sender );
    }
       
    // Get owner data
    function getWillData(uint256 _willId, address _owalletAddress) internal view returns(owner_of_the_will storage )
    {
        require(_owalletAddress == allWills.wills[_willId].o_wallet_address, "You are not Authorized to access this account");
        return(allWills.wills[_willId]);
    }

    // Use this public function to call the Internal function to get the the will
    function getWill(uint256 _willId, address _owalletAddress) public view returns (owner_of_the_will memory){
        return(getWillData(_willId, _owalletAddress));
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
        emit setBeneficiaryData(block.timestamp, msg.sender );
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
        emit setBeneficiaryToWill(block.timestamp, msg.sender );

    }
    // update will beneficiaries once all the beneficiaries are added to the array
    function setBeneficiaries_in_will(uint256 _willId) internal {
        willMap storage will = allWills;
        will.wills[_willId].beneficiaries = beneficiariesOfWill;
        delete beneficiariesOfWill;
    }
    // Use this public function to call the Internal function to set the beneficiaries in the will
    function setBeneInternalFuncCall(uint256 _willId) public {
        setBeneficiaries_in_will(_willId);
     }    
    // get all beneficiaries
   /* function getBeneficiaries(uint256 _willId, string memory _ossn) public view returns(beneficiary[] memory){
        for(uint256 i; i < allWills.wills[_willId].beneficiaries.length; i++){
            if(compareTwoStrings(allWills.wills[_willId].o_ssn, _ossn)){
                return(allWills.wills[_willId].beneficiaries);
            }
        }*/
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
    function updateBeneficiaryWallet(string memory _ssn, address _walletAddress) public onlyOwner returns(bool) {
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
    }

    // compares two strings
    function compareTwoStrings(string memory string1, string memory string2) public pure returns (bool)
    {
        return keccak256(abi.encodePacked(string1)) == keccak256(abi.encodePacked(string2));
    }
}
