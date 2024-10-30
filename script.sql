create table stock
(
    code     varchar(20) not null,
    name     varchar(50) not null,
    price    double      not null,
    security int         not null,
    profit   double      not null,
    constraint stock_code_uindex
        unique (code),
    constraint stock_name_uindex
        unique (name)
);

alter table stock
    add primary key (code);

create table user
(
    id       int auto_increment,
    password varchar(50) not null,
    time     datetime    not null,
    constraint user_id_uindex
        unique (id)
);

alter table user
    add primary key (id);

create table bid
(
    id           int auto_increment,
    time         datetime    not null,
    `user id`    int         not null,
    `stock code` varchar(20) not null,
    `bid amount` double      not null,
    constraint bid_id_uindex
        unique (id),
    constraint bid_stock_code_fk
        foreign key (`stock code`) references stock (code),
    constraint bid_user_id_fk
        foreign key (`user id`) references user (id)
);

alter table bid
    add primary key (id);

create table `stock info`
(
    id          int auto_increment,
    user        int          not null,
    information varchar(200) not null,
    constraint `stock info_id_uindex`
        unique (id),
    constraint `stock info_user_id_fk`
        foreign key (user) references user (id)
);

alter table `stock info`
    add primary key (id);

create table subscriptions
(
    id           int auto_increment,
    user         int         not null,
    `stock code` varchar(20) not null,
    type         varchar(10) not null,
    constraint subscriptions_id_uindex
        unique (id),
    constraint subscriptions_stock_code_fk
        foreign key (`stock code`) references stock (code),
    constraint subscriptions_user_id_fk
        foreign key (user) references user (id)
);

alter table subscriptions
    add primary key (id);


