import os
import json
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
    with open(Path('./contracts/compiled/initiator_of_the_will.abi.json')) as f:
        will_abi = json.load(f)

    # Set the contract address (this is the address of the deployed contract)
    contract_address = os.getenv("SMART_CONTRACT_ADDRESS")

    # Get the contract
    contract = w3.eth.contract(
        address=contract_address,
        abi=will_abi
    )

    return contract


# Load the contract
contract = load_contract()


################################################################################
# Register New Artwork
################################################################################
st.title("New Will")
#accounts = w3.eth.accounts
firstName = st.text_input("Enter the First Name of the owner of the will")
lastName = st.text_input("Enter the Last Name of the owner of the will")
ssn = st.text_input("Enter the Social Security Number of the owner of the will")
dob = st.text_input("Enter the Date of Birth of the owner of the will")
walletAddress = st.text_input("The Wallet Address of the owner of the will")
if st.button("Register will"):
    tx_hash = contract.functions.setStateVar(firstName, lastName, ssn, dob, walletAddress).transact({'from': walletAddress, 'gas': 1000000})
    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    st.write("Transaction receipt mined:")
    st.write(dict(receipt))
st.markdown("---")

################################################################################
# Display a Token
################################################################################
#st.markdown("## Display an Art Token")
#selected_address = st.selectbox("Select Account", options=accounts)
#tokens = contract.functions.balanceOf(selected_address).call()
#st.write(f"This address owns {tokens} tokens")
#token_id = st.selectbox("Artwork Tokens", list(range(tokens)))
#if st.button("Display"):
    # Get the art token owner
#    owner = contract.functions.ownerOf(token_id).call()
#    st.write(f"The token is registered to {owner}")

    # Get the art token's URI
#    token_uri = contract.functions.tokenURI(token_id).call()
#    st.write(f"The tokenURI is {token_uri}")
#    st.image(token_uri)
