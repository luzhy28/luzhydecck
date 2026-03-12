// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title 全女临终关怀链上社区：服务预订、支付、护工身份管理、评价系统合约
contract EndOfLifeCareCommunity {
    enum OrderStatus { Created, Accepted, Completed, Cancelled }

    struct Service {
        uint256 serviceId;
        string title;      // 如"临终陪伴"
        uint256 price;     // 以wei为单位
        address provider;
        bool active;
    }

    struct Order {
        uint256 orderId;
        uint256 serviceId;
        address user;
        address provider;
        uint256 bookedAt;
        OrderStatus status;
        uint256 amount;
        bool rated;
    }

    struct Rating {
        uint8 score;       // 1-5
        string comment;    // 用户评论
    }

    struct WorkerProfile {
        bool isWorker;
        string name;
        string contactInfo;
        uint256 ratingCount;
        uint256 ratingSum;
    }

    struct UserProfile {
        string name;
        string contactInfo;
    }

    uint256 public nextServiceId;
    uint256 public nextOrderId;

    mapping(uint256 => Service) public services;
    mapping(uint256 => Order) public orders;

    mapping(address => WorkerProfile) public workerProfiles;
    mapping(address => UserProfile) public userProfiles;

    mapping(uint256 => Rating) public orderRatings; // 订单=>评价

    event ServiceCreated(uint256 indexed serviceId, string title, address indexed provider, uint256 price);
    event OrderCreated(uint256 indexed orderId, address indexed user, uint256 serviceId, uint256 amount);
    event OrderAccepted(uint256 indexed orderId, address indexed provider);
    event OrderCompleted(uint256 indexed orderId);
    event OrderCancelled(uint256 indexed orderId);
    event WorkerRegistered(address indexed worker, string name);
    event UserRegistered(address indexed user, string name);
    event OrderRated(uint256 indexed orderId, address indexed worker, uint8 score, string comment);

    // =========== 用户注册、护工注册 ===========
    function registerUser(string memory name, string memory contactInfo) public {
        userProfiles[msg.sender] = UserProfile(name, contactInfo);
        emit UserRegistered(msg.sender, name);
    }

    function registerWorker(string memory name, string memory contactInfo) public {
        workerProfiles[msg.sender].isWorker = true;
        workerProfiles[msg.sender].name = name;
        workerProfiles[msg.sender].contactInfo = contactInfo;
        emit WorkerRegistered(msg.sender, name);
    }

    // =========== 服务管理与预订 ===========
    function createService(string calldata title, uint256 price) public {
        require(workerProfiles[msg.sender].isWorker, "需先注册为护工");
        require(price > 0, "价格必须大于0");
        services[nextServiceId] = Service({
            serviceId: nextServiceId,
            title: title,
            price: price,
            provider: msg.sender,
            active: true
        });
        emit ServiceCreated(nextServiceId, title, msg.sender, price);
        nextServiceId++;
    }

    function bookService(uint256 serviceId) public payable {
        Service memory s = services[serviceId];
        require(s.active, "服务未激活或不存在");
        require(msg.value == s.price, "支付金额不正确");

        orders[nextOrderId] = Order({
            orderId: nextOrderId,
            serviceId: serviceId,
            user: msg.sender,
            provider: s.provider,
            bookedAt: block.timestamp,
            status: OrderStatus.Created,
            amount: msg.value,
            rated: false
        });
        emit OrderCreated(nextOrderId, msg.sender, serviceId, msg.value);
        nextOrderId++;
    }

    function acceptOrder(uint256 orderId) public {
        Order storage o = orders[orderId];
        require(msg.sender == o.provider, "只有服务提供者可接单");
        require(o.status == OrderStatus.Created, "状态不正确");
        o.status = OrderStatus.Accepted;
        emit OrderAccepted(orderId, msg.sender);
    }

    function completeOrder(uint256 orderId) public {
        Order storage o = orders[orderId];
        require(msg.sender == o.user || msg.sender == o.provider, "无权操作");
        require(o.status == OrderStatus.Accepted, "仅可完成已接单订单");
        o.status = OrderStatus.Completed;
        payable(o.provider).transfer(o.amount);
        emit OrderCompleted(orderId);
    }

    function cancelOrder(uint256 orderId) public {
        Order storage o = orders[orderId];
        require(msg.sender == o.user, "仅用户可取消");
        require(o.status == OrderStatus.Created, "仅可取消未被接单的订单");
        o.status = OrderStatus.Cancelled;
        payable(o.user).transfer(o.amount);
        emit OrderCancelled(orderId);
    }

    // =========== 订单评价 ===========
    function rateOrder(uint256 orderId, uint8 score, string memory comment) public {
        Order storage o = orders[orderId];
        require(o.status == OrderStatus.Completed, "仅可评价已完成的订单");
        require(msg.sender == o.user, "仅下单用户可评价");
        require(!o.rated, "已经评价过了");
        require(score >= 1 && score <= 5, "评分区间1-5");

        orderRatings[orderId] = Rating({
            score: score,
            comment: comment
        });
        o.rated = true;

        // 更新护工评分
        workerProfiles[o.provider].ratingCount += 1;
        workerProfiles[o.provider].ratingSum += score;

        emit OrderRated(orderId, o.provider, score, comment);
    }

    // =========== 查询接口（辅助 Remix 展示） ===========
    function getOrder(uint256 orderId) public view returns (
        uint256, uint256, address, address, uint256, OrderStatus, uint256, bool
    ) {
        Order memory o = orders[orderId];
        return (o.orderId, o.serviceId, o.user, o.provider, o.bookedAt, o.status, o.amount, o.rated);
    }

    function getWorkerProfile(address worker) public view returns(
        string memory, string memory, uint256, uint256, uint256, uint256
    ) {
        WorkerProfile memory w = workerProfiles[worker];
        return (
            w.name, w.contactInfo, 
            w.ratingSum, w.ratingCount, 
            w.ratingCount > 0 ? w.ratingSum / w.ratingCount : 0, // 平均分
            w.isWorker ? 1 : 0
        );
    }

    function getUserProfile(address user) public view returns(string memory, string memory) {
        UserProfile memory u = userProfiles[user];
        return (u.name, u.contactInfo);
    }

    function getOrderRating(uint256 orderId) public view returns (uint8, string memory) {
        Rating memory r = orderRatings[orderId];
        return (r.score, r.comment);
    }
}