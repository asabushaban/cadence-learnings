# Ch1 Day 1

## Explain what the Blockchain is in your own words.

a blockchain is a distributed network where information can be stored publicly. Users can interact with that information without restriction from centralized authorities. Blockchains typically have certain properties to protect users from scams and fordgery. Inheritly, blockchains allow for users to rely on distributed programming consensus (Math) instead of trusted (centralized) third parties, without compromosing security.

## Explain what a Smart Contract is.

a smart contract is logic deployed to the blockchain that allows users to change the state of data stored on the blockchain.

## Explain the difference between a script and a transaction.

a script allows a user to read information on the blockchain while a transaction allows users to create, update, or delete information on the blockchain. A transaction typically has fees associated with its execution in the form of the blockchains native token. These "gas fees" serve as an incentive to the validators who mantain the integrity of the network.

# Ch1 Day 2

## What are the 5 Cadence Programming Language Pillars?

    Safety and Security
    Clarity
    Approachability
    Developer Experience
    Resource Oriented Programming

## In your opinion, even without knowing anything about the Blockchain or coding, why could the 5 Pillars be useful (you don't have to answer this for #5)?

    Of course safety ad security are always top priority bc people value the rights and property.

    Clarity is important to allow other to easily understand and work on your code, code that only you understand limits the development of your code, because then only you can contribute.

    Approachability allows for devs to quickly pickup on a language. Shortening the learning process allows removes a barrier to entry and allows for a growing community, in hopes to make the project a standard.

    Dev Exp: Devs like easy to debug and understand languages. A balance of control, yet not too much typing is always ideal.

# Ch2 Day 1

### Deploy a contract to account 0x03 called "JacobTucker". Inside that contract, declare a constant variable named is, and make it have type String. Initialize it to "the best" when your contract gets deployed.

### Check that your variable is actually equals "the best" by executing a script to read that variable. Include a screenshot of the output.

![First Smart Contract](First-Smart-Contract.png)

# Ch2 Day 2

## 1.) Explain why we wouldn't call changeGreeting in a script.

changeGreeting changes the state of the greeting variable in the smart contract. Scripts do not change the state of variables in smart contracts, this functionality is exclusive to transactions.

## 2.) What does the AuthAccount mean in the prepare phase of the transaction?

the AuthAccount is the parameter taken into the prepare phase of the transaction. This AuthAccount approves the transaction ("signs it") and pays the gas fees to execute the transaction.

## 3.) What is the difference between the prepare phase and the execute phase in the transaction?

the prepare phase access the data in the account, like a gatekeeper to approve the manipulation of resources. The execute phase can not access data in the account, but it can call functions to actually do the manipulation of the data on the blockchain, after everything checks out in the prepare phase.

## 4.) Add two new things inside your contract:

    1.) A variable named myNumber that has type Int (set it to 0 when the contract is deployed)

    2.) A function named updateMyNumber that takes in a new number named newNumber as a parameter that has type Int and updates myNumber to be newNumber

    Add a script that reads myNumber from the contract

    Add a transaction that takes in a parameter named myNewNumber and passes it into the updateMyNumber function. Verify that your number changed by running the script again.

![First Transaction](First-Transaction.png)
