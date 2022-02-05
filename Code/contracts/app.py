import os
import json
from unittest.util import _MAX_LENGTH
from web3 import Web3
from pathlib import Path
from dotenv import load_dotenv
import streamlit as st

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

accounts = w3.eth.accounts
_account = st.selectbox("Select Account", options=accounts)

# testing who is the owner
st.write(contract.functions.getOwner().call())

################################################################################
# Register New Artwork
################################################################################
st.title("New Will")
#accounts = w3.eth.accounts
firstName = st.text_input("Enter the First Name of the owner of the will")
lastName = st.text_input("Enter the Last Name of the owner of the will")
ssn = st.text_input("Enter the Social Security Number of the owner of the will format ", value = "XXX-XX-XXXX", type="password", max_chars=11)
dob = st.date_input("Enter the Date of Birth of the owner of the will")
walletAddress = st.text_input("The Wallet Address of the owner of the will")
if st.button("Register will"):
    tx_hash = contract.functions.setOwnerdata(firstName, lastName, str(ssn), str(dob),
     walletAddress).transact({'from': walletAddress, 'gas': 1000000})
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
b_ssn = st.text_input("Enter the Social Security Number of the Beneficiary ", value = "XXX-XX-XXXX", type="password", max_chars=11)
b_dob = st.date_input("Enter the Date of Birth of the Beneficiary")
b_share = st.number_input("Enter the share of the estate", max_value=100)
b_walletAddress = st.text_input("The Wallet Address of the Beneficiary")


if st.button("Register Beneficiary"):
    tx_hash = contract.functions.setBeneCallInternalFunc(b_firstName, b_lastName, 
    str(b_ssn), str(b_dob), int(b_share), b_walletAddress).transact({'from': walletAddress, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))


st.markdown("---")

# Get the willId to attach the beneificaries list to
_willId = st.text_input("Enter the Will ID to attach the Beneficiary list")
if st.button("Add Beneficiary to the will"):
    tx_hash = contract.functions.setBeneInternalFuncCall(int(_willId)).transact({'from': walletAddress, 'gas': 1000000})
    st.write(contract.functions.setBeneInternalFuncCall(int(_willId)).call())
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
    
    st.markdown("---")

with st.sidebar:
    _owillId = st.text_input("Enter the Owner Will ID")
    #_ossn = st.text_input("Enter the SSN")
    st.markdown("Click on the buttons below to Review Data")
    if st.button("View Will Owner Data"):
        ownerData = contract.functions.getWill(int(_owillId)).call()
        st.write("Owner Data:")
        st.write(ownerData)
        
 
    _bwillId = st.text_input("Enter the Beneficiary Will ID")
    _bssn = st.text_input("Enter the Beneficiary SSN")
    if st.button("View Beneficiary Info"):
        beneData = contract.functions.getBeneficiaries(int(_bwillId), _bssn).call()
        st.write("Beneficiary Data:")
        st.write(beneData)
