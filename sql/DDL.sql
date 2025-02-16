-- auto-generated definition
create table user
(
    user_id           int auto_increment
        primary key,
    login             varchar(50)                                      not null,
    password_hash     varchar(255)                                     not null,
    phone_number      varchar(15)                                      null,
    registration_date datetime                                         not null,
    last_login        datetime                                         null,
    last_payment_date datetime                                         null,
    is_blocked        tinyint(1)             default 0                 null,
    is_partner        tinyint(1)             default 0                 null,
    role              enum ('admin', 'user') default 'user'            null,
    created_at        datetime               default CURRENT_TIMESTAMP null,
    updated_at        datetime               default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint login
        unique (login)
);

-- auto-generated definition
create table brokers
(
    broker_id   int auto_increment
        primary key,
    broker_name varchar(100)                       not null,
    created_at  datetime default CURRENT_TIMESTAMP null,
    constraint broker_name
        unique (broker_name)
);

-- auto-generated definition
create table user_brokers
(
    user_broker_id int auto_increment
        primary key,
    user_id        int not null,
    broker_id      int not null,
    constraint user_brokers_ibfk_1
        foreign key (user_id) references user (user_id),
    constraint user_brokers_ibfk_2
        foreign key (broker_id) references brokers (broker_id)
);

create index broker_id
    on user_brokers (broker_id);

create index user_id
    on user_brokers (user_id);

-- auto-generated definition
create table orders
(
    order_id         int auto_increment
        primary key,
    user_id          int                                                                           not null,
    broker_id        int                                                                           not null,
    asset_name       varchar(100)                                                                  not null,
    order_type       enum ('market', 'limit', 'take-profit', 'stop-loss', 'trailing-stop')         not null,
    quantity         int                                                                           not null,
    price            decimal(10, 2)                                                                null,
    activation_price decimal(10, 2)                                                                null,
    execution_type   enum ('market', 'limit')                                                      null,
    expiration_type  enum ('unlimited', 'specific')                                                null,
    expiration_date  date                                                                          null,
    offset_value     decimal(10, 2)                                                                null,
    offset_type      enum ('currency', 'percentage')                                               null,
    activation_type  enum ('immediate', 'delayed')                                                 null,
    spread_value     decimal(10, 2)                                                                null,
    spread_type      enum ('currency', 'percentage')                                               null,
    status           enum ('pending', 'placed', 'completed', 'canceled') default 'pending'         null,
    created_at       datetime                                            default CURRENT_TIMESTAMP null,
    updated_at       datetime                                            default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint orders_ibfk_1
        foreign key (user_id) references user (user_id),
    constraint orders_ibfk_2
        foreign key (broker_id) references brokers (broker_id)
);

create index broker_id
    on orders (broker_id);

create index user_id
    on orders (user_id);

-- auto-generated definition
create table deals
(
    deal_id     int auto_increment
        primary key,
    user_id     int                                                                           not null,
    asset_name  varchar(100)                                                                  not null,
    broker_id   int                                                                           not null,
    order_id    int                                                                           null,
    order_type  enum ('market', 'limit', 'take-profit', 'stop-loss', 'trailing-stop')         not null,
    entry_price decimal(10, 3)                                                                null,
    exit_price  decimal(10, 3)                                                                null,
    volume      int                                                                           not null,
    status      enum ('pending', 'placed', 'completed', 'canceled') default 'pending'         null,
    net_result  decimal(10, 3)                                                                null,
    broker_fee  decimal(10, 3)                                                                null,
    created_at  datetime                                            default CURRENT_TIMESTAMP null,
    updated_at  datetime                                            default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint deals_ibfk_1
        foreign key (user_id) references user (user_id),
    constraint deals_ibfk_2
        foreign key (broker_id) references brokers (broker_id),
    constraint deals_ibfk_3
        foreign key (order_id) references orders (order_id)
);

create index broker_id
    on deals (broker_id);

create index order_id
    on deals (order_id);

create index user_id
    on deals (user_id);

-- auto-generated definition
create table bond_search_filters
(
    filter_id   int auto_increment
        primary key,
    user_id     int                                not null,
    filter_name varchar(100)                       not null,
    filter_data json                               not null,
    created_at  datetime default CURRENT_TIMESTAMP null,
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint bond_search_filters_ibfk_1
        foreign key (user_id) references user (user_id)
);

create index user_id
    on bond_search_filters (user_id);

-- auto-generated definition
create table indicator_templates
(
    template_id   int auto_increment
        primary key,
    user_id       int                                not null,
    template_name varchar(100)                       not null,
    template_data json                               not null,
    created_at    datetime default CURRENT_TIMESTAMP null,
    updated_at    datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint indicator_templates_ibfk_1
        foreign key (user_id) references user (user_id)
);

create index user_id
    on indicator_templates (user_id);

-- auto-generated definition
create table bond_watchlists
(
    watchlist_id   int auto_increment
        primary key,
    user_id        int                                not null,
    watchlist_name varchar(100)                       not null,
    watchlist_data json                               not null,
    created_at     datetime default CURRENT_TIMESTAMP null,
    updated_at     datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint bond_watchlists_ibfk_1
        foreign key (user_id) references user (user_id)
);

create index user_id
    on bond_watchlists (user_id);









