import React, {Component} from 'react';
import {
  ButtonGroup, Col, ControlLabel, DropdownButton, FormControl, FormGroup,
  MenuItem
} from "react-bootstrap";
import '../styles/StatesFilter.css'
import APIClient from "../APIClient";


class StatesFilter extends Component {
  constructor(...args) {
    super(...args);

    this.state = {
      states: {}
    };
  }

  componentWillMount() {
    APIClient.getStates(statesData => {
      let states = statesData.reduce((_states, state) => {
        _states[state.abbreviation] = state.name;
        return _states;
      }, {});
      this.setState({...this.state, states: states});
    });
  }

  stateOption(stateAbbreviation) {
    return this.state.states[stateAbbreviation] + ' (' + stateAbbreviation + ')';
  }

  title() {
    return this.props.value ? this.stateOption(this.props.value) : "Choose State";
  }

  render() {
    return (
        <FormGroup controlId={"stateFilter"}>
          <FormControl.Feedback/>
          <Col xs={12} sm={5} md={4} className={"label-container"}>
            <ControlLabel>State</ControlLabel>
          </Col>
          <Col xs={12} sm={7} md={7} lg={6}>
            <ButtonGroup justified className={"states-drop-down-container"}>
              <DropdownButton id={"statesDropDown"}
                              key={"stateFilter"}
                              title={this.title()}
                              onSelect={this.props.handleChange}>
                  <MenuItem eventKey={null}>Choose State</MenuItem>
                  <MenuItem divider/>
                  {Object.keys(this.state.states).map((stateAbbreviation) => {
                    return <MenuItem
                        active={stateAbbreviation === this.props.value}
                        key={stateAbbreviation}
                        eventKey={stateAbbreviation}>
                      {this.stateOption(stateAbbreviation)}
                    </MenuItem>
                  })}
              </DropdownButton>
            </ButtonGroup>
          </Col>
        </FormGroup>
    );
  }
}

export default StatesFilter;