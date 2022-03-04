/**

## The Flow Non-Fungible Token standard

## `NonFungibleToken` contract interface

The interface that all non-fungible token contracts could conform to.
If a user wants to deploy a new nft contract, their contract would need
to implement the NonFungibleToken interface.

Their contract would have to follow all the rules and naming
that the interface specifies.

## `NFT` resource

The core resource type that represents an NFT in the smart contract.

## `Collection` Resource

The resource that stores a user's NFT collection.
It includes a few functions to allow the owner to easily
move tokens in and out of the collection.

## `Provider` and `Receiver` resource interfaces

These interfaces declare functions with some pre and post conditions
that require the Collection to follow certain naming and behavior standards.

They are separate because it gives the user the ability to share a reference
to their Collection that only exposes the fields and functions in one or more
of the interfaces. It also gives users the ability to make custom resources
that implement these interfaces to do various things with the tokens.

By using resources and interfaces, users of NFT smart contracts can send
and receive tokens peer-to-peer, without having to interact with a central ledger
smart contract.

To send an NFT to another user, a user would simply withdraw the NFT
from their Collection, then call the deposit function on another user's
Collection to complete the transfer.

*/

// The main NFT contract interface. Other NFT contracts will
// import and implement this interface

pub contract interface NonFungibleToken {

    // The total number of tokens of this type in existence
    pub var totalSupply: UInt64

    // Event that emitted when the NFT contract is initialized
    //
    pub event ContractInitialized()

    // Event that is emitted when a token is withdrawn,
    // indicating the owner of the collection that it was withdrawn from.
    //
    // If the collection is not in an account's storage, `from` will be `nil`.
    //
    pub event Withdraw(id: UInt64, from: Address?)

    // Event that emitted when a token is deposited to a collection.
    //
    // It indicates the owner of the collection that it was deposited to.
    //
    pub event Deposit(id: UInt64, to: Address?)

    // Interface that the NFTs have to conform to
    //
    pub resource interface INFT {
        // The unique ID that each NFT has
        pub let id: UInt64
    }

    // Requirement that all conforming NFT smart contracts have
    // to define a resource called NFT that conforms to INFT
    pub resource NFT: INFT {
        pub let id: UInt64
    }

    // Interface to mediate withdraws from the Collection
    //
    pub resource interface Provider {
        // withdraw removes an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NFT {
            post {
                result.id == withdrawID: "The ID of the withdrawn token must be the same as the requested ID"
            }
        }
    }

    // Interface to mediate deposits to the Collection
    //
    pub resource interface Receiver {

        // deposit takes an NFT as an argument and adds it to the Collection
        //
        pub fun deposit(token: @NFT)
    }

    // Interface that an account would commonly
    // publish for their collection
    pub resource interface CollectionPublic {
        pub fun deposit(token: @NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NFT
    }

    // Requirement for the the concrete resource type
    // to be declared in the implementing contract
    //
    pub resource Collection: Provider, Receiver, CollectionPublic {

        // Dictionary to hold the NFTs in the Collection
        pub var ownedNFTs: @{UInt64: NFT}

        // withdraw removes an NFT from the collection and moves it to the caller
        pub fun withdraw(withdrawID: UInt64): @NFT

        // deposit takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        pub fun deposit(token: @NFT)

        // getIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64]

        // Returns a borrowed reference to an NFT in the collection
        // so that the caller can read data and call methods from it
        pub fun borrowNFT(id: UInt64): &NFT {
            pre {
                self.ownedNFTs[id] != nil: "NFT does not exist in the collection!"
            }
        }
    }

    // createEmptyCollection creates an empty Collection
    // and returns it to the caller so that they can own NFTs
    pub fun createEmptyCollection(): @Collection {
        post {
            result.getIDs().length == 0: "The created collection must be empty!"
        }
    }
}


// TopJockNFT

// import NonFungibleToken from 0x02

pub contract TopJockNFT: NonFungibleToken {

    pub var totalSupply: UInt64
    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)

    pub resource NFT: NonFungibleToken.INFT {
        pub let id: UInt64
        // pub let name: String

        init(){
            self.id = TopJockNFT.totalSupply
            TopJockNFT.totalSupply = TopJockNFT.totalSupply + 1
            // self.name = "Amjad"
        }
    }

    pub resource interface MyCollectionPublic{
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowEntireNFT(id: UInt64): &NFT
    }

    pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MyCollectionPublic {
        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

        pub fun deposit(token: @NonFungibleToken.NFT){
            let topJock <- token as! @NFT
            emit Deposit(id: topJock.id, to: self.owner?.address)
            self.ownedNFTs[topJock.id] <-! topJock
        }

        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT{
            let jock <- self.ownedNFTs.remove(key: withdrawID) ?? panic("This collection does not contain the NFT you're looking for.")
            emit Withdraw(id:withdrawID, from:self.owner?.address)
            return <- jock
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return &self.ownedNFTs[id] as &NonFungibleToken.NFT
        }

        pub fun borrowEntireNFT(id: UInt64): &NFT {
            let refNFT = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT
            return refNFT as! &NFT
        }

        init(){
            self.ownedNFTs <- {}
        }

        destroy(){
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    pub resource NFTMinter {

        pub fun createNFT(): @NFT {
            return <- create NFT()
        }

        init(){}
    }

    init() {
        self.totalSupply = 0
        emit ContractInitialized()
        self.account.save(<- create NFTMinter(), to: /storage/Minter)
    }
}


//Transactions
// Create Collection
// import TopJockNFT from 0x01
// import NonFungibleToken from 0x02
transaction {
    prepare(account: AuthAccount) {
        account.save(<-TopJockNFT.createEmptyCollection(), to: /storage/Collection)
        account.link<&TopJockNFT.Collection{NonFungibleToken.CollectionPublic, TopJockNFT.MyCollectionPublic}>(/public/Collection, target: /storage/Collection)
    }

    execute {
        log("stored a Collection for our Jocks")
    }
}

// Deposit Jock
// import TopJockNFT from 0x01
// import NonFungibleToken from 0x02

transaction(recipient: Address) {
    prepare(account: AuthAccount) {
        let nftMinter = account.borrow<&TopJockNFT.NFTMinter>(from: /storage/Minter)!

        let publicReference = getAccount(recipient).getCapability(/public/Collection)
                                .borrow<&TopJockNFT.Collection{NonFungibleToken.CollectionPublic}>()
                                ?? panic("This account does not have a Collection")

        publicReference.deposit(token: <- nftMinter.createNFT())
    }

    execute {
        log("stored a newly minted Jock in your collection")
    }
}

// Transfer NFT

// import TopJockNFT from 0x01
// import NonFungibleToken from 0x02

// the receiver of the jock is the recipient (duh)
transaction(recipient: Address, id:UInt64) {
// the giver of the Jock is the account is signing
    prepare(account: AuthAccount) {

    let collection = account.borrow<&TopJockNFT.Collection>(from: /storage/Collection)!

    let publicReference = getAccount(recipient).getCapability(/public/Collection)
                            .borrow<&TopJockNFT.Collection{NonFungibleToken.CollectionPublic}>()
                            ?? panic("This account does not have a Collection")

    publicReference.deposit(token: <- collection.withdraw(withdrawID: id))
    }

    execute {
    log("Jock transfered successfully ")
    }
}

// Scripts
// Read the IDs of the NFTs in a Collection for a certain account
// import TopJockNFT from 0x01
// import NonFungibleToken from 0x02


pub fun main(account: Address): [UInt64] {
    let publicReference = getAccount(account).getCapability(/public/Collection)
                                .borrow<&TopJockNFT.Collection{NonFungibleToken.CollectionPublic}>()
                                ?? panic("This account does not have a Collection")


    return publicReference.getIDs()
}

// Read name
// import TopJockNFT from 0x01
// import NonFungibleToken from 0x02

// pub fun main(account: Address, id:UInt64): String {
//     let publicReference = getAccount(account).getCapability(/public/Collection)
//                                 .borrow<&TopJockNFT.Collection{TopJockNFT.MyCollectionPublic}>()
//                                 ?? panic("This account does not have a Collection")

//     return publicReference.borrowEntireNFT(id: id).name

// }
