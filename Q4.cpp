//Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

//in order to fix the memory leak, my approach was to free up any pointer allocation before any return statements as seen below
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);

    if (!player) {
        player = new Player(nullptr);
     
        //this functions returns whether or not player can be loaded in from a database, according to documentation here -> https://github.com/otland/forgottenserver/blob/master/src/iologindata.cpp
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            //if player cannot be loaded, we can just free up the player space here and cancel any further function execution  
            //this should take care of the memory leak
            delete player;
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        //if item could not be created, we will clear out player pointer before returning
        delete player;
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    // free up pointers if they were created
    if(player != nullptr) {
        delete player; 
    }
    
    if(item != nullptr) {   
        delete item;      
    }
}