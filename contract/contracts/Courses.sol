// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Courses is ERC20{

    address public admin;
    struct course_info{
        address instructor_id;
        uint credits_required;
        address[] teaching_to;
        address[] taught_to;
    }

    struct student_info{
        uint[] learned;
        uint learnedCourses; 
    }

    mapping(uint => course_info) course;
    mapping(address => student_info) student;
    
    modifier min_creation_cost(uint course_cost){
        require(course_cost > 0);
        _;
    }
    
    modifier valid_cost(uint minCost, uint currCost){
        require(currCost >= minCost);
        _;
    }

    modifier teacher_learner_validate(address teacher, address learner){
        require(teacher != learner);
        _;
    }

    constructor() ERC20("Coursify", "CFY") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == admin, 'only admin');
        _mint(to, amount);
    }

    function add_course(uint course_id, uint cost) public min_creation_cost(cost){ // teacher, invoker
        address inst_id = msg.sender;

        course[course_id].instructor_id = inst_id;
        course[course_id].credits_required = cost;
    }

    // function learn_course(uint course_id, uint amount) public payable valid_cost(course[course_id].credits_required, msg.value) teacher_learner_validate(course[course_id].instructor_id, msg.sender){
    function learn_course(uint course_id, uint amount) public valid_cost(course[course_id].credits_required, amount) teacher_learner_validate(course[course_id].instructor_id, msg.sender){
        // address payable instructor_addr = payable(course[course_id].instructor_id);
        address instructor_addr = course[course_id].instructor_id;
        // console.log("id", course[course_id].instructor_id, instructor_addr);

        // bool sent = instructor_addr.send(msg.value);
        _transfer(msg.sender, instructor_addr, amount);
        // require(sent, "Failed to send Ether");

        course[course_id].teaching_to.push(msg.sender);
        student[msg.sender].learned.push(course_id);
        student[msg.sender].learnedCourses += 1;
    }

    function get_learner_level() public view returns(string memory badge){
        address studentAddr = msg.sender;
        uint numCourses = student[studentAddr].learnedCourses;

        if (numCourses <= 1){
            badge = "bronze";
        }
        else if (numCourses == 2){
            badge = "silver";
        }
        else if (numCourses == 3){
            badge = "gold";
        }
        else{
            badge = "platinum";
        }
    }

    function learners_for_course(uint course_id) public view returns(address[] memory learners){
        learners = course[course_id].teaching_to;
    }

    function learned_courses() public view returns(uint[] memory courses){
        courses = student[msg.sender].learned;
    }
}