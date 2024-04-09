// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SistemaVotacion {
    struct Propuesta {
        string nombre;
        uint votos;
    }

    mapping(address => bool) public whitelist;
    mapping(string => Propuesta) public propuestas;
    mapping(address => bool) public haVotado;
    address public owner;
    uint public tiempoInicio;

    modifier soloOwner() {
        require(msg.sender == owner, "Solo el propietario puede realizar esta accion");
        _;
    }
    modifier enTiempoVotacion() {
        require(block.timestamp <= tiempoInicio + 3 days, "El tiempo de votacion ha expirado");
        _;
    }


    constructor() {
        owner = msg.sender;
        tiempoInicio = block.timestamp;
    }

    function agregarPropuesta(string memory _nombre) public soloOwner {
        propuestas[_nombre] = Propuesta(_nombre, 0);
    }

    function agregarALaWhitelist(address _address) public soloOwner {
        whitelist[_address] = true;
    }

    function eliminarDeLaWhitelist(address _address) public soloOwner {
        whitelist[_address] = false;
    }

    function getVotosPropuesta(string memory _nombrePropuesta) public view returns (uint) {
        return propuestas[_nombrePropuesta].votos;
    }


    function votar(string memory _nombrePropuesta) public enTiempoVotacion {
        require(whitelist[msg.sender], "No estas autorizado para votar");
        require(!haVotado[msg.sender], "Ya has votado");

        propuestas[_nombrePropuesta].votos++;
        haVotado[msg.sender] = true;
    }


}