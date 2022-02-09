import os
import json
from unittest.util import _MAX_LENGTH
from numpy import require
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st
import web3

load_dotenv()

# Define and connect a new Web3 provider
w3 = Web3(Web3.HTTPProvider(os.getenv("WEB3_PROVIDER_URI")))

################################################################################
# Contract Helper function:
# 1. Loads the contract once using cache
# 2. Connects to the contract using the contract address and ABI
################################################################################


@st.cache(allow_output_mutation=True)
def load_contract():

    # Load the contract ABI
    with open(Path(".\compiled\initiator_of_the_will.abi.json")) as f:
        will_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("CONTRACT_ADDRESS")

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi=will_abi
    )

    return contract


# Load the contract
contract = load_contract()

#col1, col2 = st.columns([5,2])
#with col1:
st.header("Create a Will")
################################################################################
# Register New Will
################################################################################

firstName = st.text_input("Enter the First Name of the owner of the will")
lastName = st.text_input("Enter the Last Name of the owner of the will")
ssn = st.text_input("Enter the Social Security Number of the owner of the will format XXX-XX-XXXX ", value = "XXX-XX-XXXX", type="password", max_chars=11)
dob = st.date_input("Enter the Date of Birth of the owner of the will")
walletAddress = st.text_input("The Wallet Address of the owner of the will")
execWallet = st.text_input("The Wallet Address of the Executor of the will")
execKey = st.text_input("The a secret Key for the Executor to as a password to the will")
if st.button("Register will"):
    tx_hash = contract.functions.setOwnerdata(firstName, lastName, str(ssn), str(dob),
    walletAddress, execWallet, execKey).transact({'from': walletAddress, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
    st.markdown("---")


################################################################################
# Register and Display Beneficiaries
################################################################################

st.title("Register Beneficiary")
st.subheader("!! Add all Beneficiaries before adding the list of Beneficiaries to the will !!")
b_firstName = st.text_input("Enter the First Name of the Beneficiary")
b_lastName = st.text_input("Enter the Last Name of the Beneficiary")
b_ssn = st.text_input("Enter the Social Security Number of the Beneficiary format XXX-XX-XXXX ", value = "XXX-XX-XXXX", type="password", max_chars=11)
b_dob = st.date_input("Enter the Date of Birth of the Beneficiary")
b_share = st.number_input("Enter the percentage share of the estate", max_value=100)
b_walletAddress = st.text_input("The Wallet Address of the Beneficiary")


if st.button("Register Beneficiary"):
    tx_hash = contract.functions.setBeneCallInternalFunc(b_firstName, b_lastName, 
    str(b_ssn), str(b_dob), int(b_share), b_walletAddress).transact({'from': b_walletAddress, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
    #contract.functions.removebeneficiariesOfWill().call()


st.markdown("---")

# Get the willId to attach the beneificaries list to
_willId = st.text_input("Enter the Will ID to attach the Beneficiary list")
if st.button("Add Beneficiaries to the will"):
    tx_hash = contract.functions.setBeneInternalFuncCall(int(_willId)).transact({'from': walletAddress, 'gas': 1000000})
    st.write(contract.functions.setBeneInternalFuncCall(int(_willId)).call())
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
    st.success('Congratulations, you have succesfully created the will for yourself!')
    st.balloons()
st.markdown("---")





## Sidebar Code Starts here
with st.sidebar:
    _owillId = st.text_input("Enter the Owner's Will ID")
    _owalletAddress = st.text_input("Enter the Will Owner's Wallet Address")
    #_ossn = st.text_input("Enter the SSN")
    st.markdown("Click on the buttons below to Review Data")
    if st.button("View Will Owner Data"):
        ownerData = contract.functions.getWill(int(_owillId), _owalletAddress).call()
        st.write("Owner Data:")
        st.write(ownerData)
        
 
    _bwillId = st.text_input("Enter the Beneficiary Will ID")
    _bssn = st.text_input("Enter the Beneficiary SSN format XXX-XX-XXXX ")
    if st.button("View Beneficiary Info"):
        beneData = contract.functions.getBeneficiaries(int(_bwillId), _bssn).call()
        st.write(f"Beneficiary Data: {beneData}")

    _execwallet = st.text_input("Enter the Executor's Wallet Address")
    _execKey = st.text_input("Enter the Executor's Secret Key")
    _willId = st.text_input("Enter the Will ID")
    _ownerWallet = st.text_input("Enter the Will's Wallet Address")
    _assetPKey =st.text_input("Enter the Asset's Private Key to transfer funds")


    if st.button("Assert Death and Execute the will"):
        _payees = contract.functions.assertDeath(_execwallet,_execKey, int(_willId), _ownerWallet).call()
        _assetBalance = w3.eth.get_balance(_ownerWallet)
        st.write(_assetBalance)   
        for _payee in _payees:

            _to = _payee[-1]
            _share = _payee[-2]
            st.write(_payee)
            nonce = w3.eth.getTransactionCount(_ownerWallet)
            st.write(_assetBalance)
            st.write(_share)
            gas = 300000
            value  = w3.fromWei(_assetBalance * ((_share-.02)/100), 'ether')  - w3.fromWei(int(gas), 'ether')
            #value  = _assetBalance * (_share/100)
            st.write(value)
            tx = {
                'nonce': nonce,
                'to': _to,
                'value': w3.toWei(value, 'ether'),
                'gas': gas,
                'gasPrice': w3.toWei('50', 'gwei'),   
                'chainId':1337  
            }
            signed_tx = w3.eth.account.signTransaction(tx, _assetPKey)
            tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)
            receipt = w3.eth.waitForTransactionReceipt(tx_hash)
            st.write("Transaction receipt mined:")
            st.write(dict(receipt)) 

                    
        #    st.success('You have succesfully executed the will!')
       # else:
          #  st.write("You are not authorized to execute the will")
