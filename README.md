# Estate Planning On Smart Contracts
Estate Planning to include digital assets using Smart Contracts on Ethereum Block Chain
<!-----

Yay, no errors, warnings, or alerts!

Conversion time: 0.513 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β33
* Sat Jan 22 2022 12:50:42 GMT-0800 (PST)
* Source doc: SmartContract Estate Planning
----->


SmartContract Estate Planning Project Proposal:

The platform would be a series of smart contracts that would codify the asset disposition wishes of an asset owner who has died. The smart contracts would serve as or supplement the deceased’s last will and testament.

From the perspective of the user, the application is a website where they will create and manage a smart contract that will inform all relevant parties what the user’s asset distribution intentions are in the event of their passing.

The information that would be needed to develop the series of contracts are to include:

Last Will and Testament:



* Chosen confidant(s) who will be tasked with the implementation and execution of the user’s instructions
* Comprehensive List of Assets, including
    * Cryptocurrency Wallets
    * NFT’s 
    * Bank Accounts
    * Investment accounts
* Health Care Power of Attorney (POA)
    * Advanced Medical Directive
    * Life-savings measures intentions
* Comprehensive List of Beneficiaries
    * Instructions for Beneficiaries to establish accounts required to inherit their assets (Wallets that would need to be created to receive their inheritance, for example)
* Asset Disposition Instructions (which beneficiaries are to be awarded which specific assets)

Functionality:  Asset disposition instructions will be disseminated upon one of two types of conditions:



* Informed Death
* User Inactivity

Under the first condition, informed death, the user specifies confidant(s) that can confirm their death by submitting a valid Death Certificate to the blockchain. Once a Death Certificate is recorded, the contract will execute a ‘proof-of-life’ protocol that provides an opportunity for the claimed deceased to nullify the asset distribution procedures to account for the event that the Death Certificate was entered into the blockchain erroneously or fraudulently. 

The second type of condition, user inactivity, will initialize asset disposition if certain inactivity conditions are met following a user-specified length of time (i.e. trigger the asset distribution instructions following X number of days of account inactivity).

Per Binoy – What will our login mechanism be? We may want to create a smart contract based login mechanism that would validate the login credentials of the user’s confidant. We could store the user data as non-public data elements, but then have a public authentication function for the parties that would need to access the contract corpus when the event planned for occurs.

Functionality Blueprint:



1. User enters service
2. User provides comprehensive list of assets to be included in their will, including cryptocurrency wallet addresses, NFT wallet addresses, bank or investment account information
3. User provides Healthcare POA, and medical directives
4. User provides beneficiary information
5. User provides Asset Distribution instructions
6. A contract is generated via a .sol file
7. The contract is maintained until either the user’s death or incapacitation
    1. In the event of the user’s death, the dissemination of asset distribution instructions are provided to the user’s specified confidant, who is either tasked with the execution of the user’s estate, or with providing the distribution instructions to another named estate executor/executrix.
    2. In the event of user incapacitation, medical directive information is disseminated to the user’s specified healthcare POA.
