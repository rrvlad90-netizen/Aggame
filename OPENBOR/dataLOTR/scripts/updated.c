void main()
{
    int i;
    int maxEntities = openborvariant("ent_max");
    int entityType;

    void player = NULL();
    void enemy = NULL();
    void entity;

    float playerX;
    float playerZ;
    float playerA;

    float enemyX;
    float enemyZ;
    float enemyA;

    float distanceX;
    float distanceZ;
    float distanceA;
    float overlap;
    float push;

    for(i = 0; i < maxEntities; i++)
    {
        entity = getentity(i);

        if(entity != NULL())
        {
            entityType = getentityproperty(entity, "type");

            if(entityType == openborconstant("TYPE_PLAYER"))
            {
                player = entity;
            }

            if(entityType == openborconstant("TYPE_ENEMY"))
            {
                enemy = entity;
            }
        }
    }

    if(player == NULL() || enemy == NULL())
    {
        return;
    }

    playerX = getentityproperty(player, "x");
    playerZ = getentityproperty(player, "z");
    playerA = getentityproperty(player, "a");

    enemyX = getentityproperty(enemy, "x");
    enemyZ = getentityproperty(enemy, "z");
    enemyA = getentityproperty(enemy, "a");

    distanceX = playerX - enemyX;

    if(distanceX < 0)
    {
        distanceX = -distanceX;
    }

    distanceZ = playerZ - enemyZ;

    if(distanceZ < 0)
    {
        distanceZ = -distanceZ;
    }

    distanceA = playerA - enemyA;

    if(distanceA < 0)
    {
        distanceA = -distanceA;
    }

    /*
     * X: body width.
     * Z: depth tolerance.
     * A: vertical collision height.
     */
    if(distanceX < 42 &&
       distanceZ < 20 &&
       distanceA < 60)
    {
        overlap = 42 - distanceX;
        push = overlap / 2.0;

        if(playerX <= enemyX)
        {
            playerX = playerX - push;
            enemyX = enemyX + push;
        }
        else
        {
            playerX = playerX + push;
            enemyX = enemyX - push;
        }

        changeentityproperty(
            player,
            "position",
            playerX,
            playerZ,
            playerA
        );

        changeentityproperty(
            enemy,
            "position",
            enemyX,
            enemyZ,
            enemyA
        );
    }
}