// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Blog
 * @dev A simple, decentralized blog contract that stores post metadata on-chain.
 * The actual content of the posts is stored on IPFS.
 */
contract Blog {
    // A custom data type to represent a single blog post.
    struct Post {
        uint256 id; // Unique identifier for the post
        string title; // Title of the post
        string contentCID; // The IPFS Content Identifier (CID) for the post's content
        address author; // The wallet address of the post's author
        uint256 timestamp; // The time the post was created
    }

    // A counter to ensure each post gets a unique ID.
    uint256 private _postCounter;

    // A mapping to retrieve a Post struct by its ID.
    mapping(uint256 => Post) public posts;

    // An event that is broadcasted on the network when a new post is created.
    // Our frontend will listen for this event to update the UI.
    event PostCreated(
        uint256 id,
        string title,
        string contentCID,
        address author,
        uint256 timestamp
    );

    /**
     * @dev Creates a new blog post.
     * @param _title The title of the post.
     * @param _contentCID The IPFS CID where the post's main content is stored.
     */
    function createPost(string memory _title, string memory _contentCID) public {
        require(bytes(_title).length > 0, "Title cannot be empty.");
        require(bytes(_contentCID).length > 0, "Content CID cannot be empty.");

        uint256 postId = _postCounter;

        // Create a new Post struct in memory
        Post memory newPost = Post({
            id: postId,
            title: _title,
            contentCID: _contentCID,
            author: msg.sender, // The person calling the function
            timestamp: block.timestamp // The current time on the blockchain
        });

        // Store the new post on the blockchain
        posts[postId] = newPost;

        // Increment the counter for the next post
        _postCounter++;

        // Emit the event to notify the frontend
        emit PostCreated(
            postId,
            _title,
            _contentCID,
            msg.sender,
            block.timestamp
        );
    }

    /**
     * @dev Fetches the total number of posts created.
     * @return The current value of the post counter.
     */
    function getPostCount() public view returns (uint256) {
        return _postCounter;
    }
}
