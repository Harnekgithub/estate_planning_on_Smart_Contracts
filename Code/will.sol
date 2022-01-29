pragma solidity ^0.5.17;
import "./entity.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

contract will is entity{
        using SafeMath for uint;
        modifier onlyOwner {
        require(msg.sender == owner, "You do not have permission to mint these tokens!");
        _;
        }
        address owner;
        constructor (string memory firstName, string memory lastName, string memory ssn, string memory dob, address) public {
                owner = msg.sender;

        }
        mapping (address => uint) public beneficiaryMap;
        mapping ( address => bool) public inserted;
        address[] public keys;

       // this functions gets the share of the estate a beneficiary will receive when the will is executed by an executor 
        function get(address _address) public view returns(uint) {
        //if(msg.sender == _address )
             return(beneficiaryMap[_address]);
        }
        //function onwerAccess(address _address) public onlyOnwer{


        //}
        // this functions sets the share of the estate a beneficiary will receive when the will is executed by an executor 
        function set(address _keys, uint _share ) public
        {
            beneficiaryMap[_keys] = _share;
            if(!inserted[_keys])
            {
                inserted[_keys] = true;
                keys.push(_keys);
            }
        }
        // iterate the mapping to get all beneficiaries
        function getall(uint _i) external view onlyOwner returns(uint)
        {
            return(beneficiaryMap[keys[_i]]);
        }
        function remove(address _address) public
        {
            delete beneficiaryMap[_address];
        }
}

