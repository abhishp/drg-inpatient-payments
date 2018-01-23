import React, {Component} from 'react';
import {ButtonGroup, Col, ControlLabel, Dropdown, FormControl, FormGroup, MenuItem} from "react-bootstrap";
import '../styles/StatesFilter.css'
import APIClient from "../APIClient";


class StatesFilter extends Component {
  constructor(...args) {
    super(...args);

    this.handleStateChange = this.handleStateChange.bind(this);

    this.state = {
      states: [],
      value: ''
    };
  }

  componentWillMount() {
    APIClient.getStates(states => {
      this.setState({...this.state, states: states});
    });
  }

  handleStateChange(selectedState) {
    this.setState({...this.state, value: selectedState});
    this.props.handleChange(selectedState && selectedState.abbreviation);
  }

  static stateOption(state) {
    return state.name + ' (' + state.abbreviation + ')';
  }

  title() {
    return this.state.value ? StatesFilter.stateOption(this.state.value) : "Choose State";
  }

  render() {
    return (
        <FormGroup controlId={"stateFilter"}>
          <FormControl.Feedback/>
          <Col xs={12} md={4} lg={4} className={"label-container"}>
            <ControlLabel>State</ControlLabel>
          </Col>
          <Col xs={12} md={6} lg={6}>
            <ButtonGroup justified className={"states-drop-down-container"}>
              <Dropdown id={"statesDropDown"}
                        key={"stateFilter"}>
                <Dropdown.Toggle>
                  {this.title()}
                </Dropdown.Toggle>
                <Dropdown.Menu>
                  <MenuItem eventKey={undefined} onSelect={this.handleStateChange}>
                    Choose State
                  </MenuItem>
                  <MenuItem divider/>
                  {this.state.states.map(state => {
                    return <MenuItem
                        key={state.abbreviation}
                        eventKey={state}
                        onSelect={this.handleStateChange}>
                      {StatesFilter.stateOption(state)}
                    </MenuItem>
                  })}
                </Dropdown.Menu>
              </Dropdown>
            </ButtonGroup>
          </Col>
        </FormGroup>
    );
  }
}

export default StatesFilter;