import _ from 'lodash'
import React from 'react';
import { Field, reduxForm, formValueSelector } from 'redux-form';
import { connect } from 'react-redux';
import { createProject } from '../actions/'
import { config } from '../config/'

class Azure extends React.Component {
  renderError({ error, touched }) {
    if (touched && error) {
      return (
        <div className="ui error message">
          <div className="header">{error}</div>
        </div>
      );
    }
  }

  renderInput = ({ input, label, meta, password }) => {
    const pass = password ? 'password' : 'text'
    const className = `field ${meta.error && meta.touched ? 'error' : ''}`;
    return (
      <div className={className}>
        <label>{label}</label>
        <input {...input} type={pass} autoComplete="off" />
        {this.renderError(meta)}
      </div>
    );
  };

  renderItems = (opt) => {
    return <option key={opt.value} value={opt.value} >{opt.name}</option>
  }

  renderSelect = (props) => {
    const { input, label, meta, data } = props;
    const className = `field ${meta.error && meta.touched ? 'error' : ''}`;
    return (
      <div className={className}>
        <label>{label}</label>
        <select {...input} className="ui selection dropdown">
          <option key={'default'}>Select</option>
          {data.map(this.renderItems)}
        </select>
        {this.renderError(meta)}
      </div>
    );
  };

  renderFWBlock = (_, i) => {
    return (
      <div  style={{marginBottom: '20px', marginTop: '50px'}} key={i}>
        <div className="ui horizontal divider">
          {`Firewall ${i+1} Configuration`} 
        </div>
        <Field name={`fwname_${i}`} component={this.renderInput} label="FW Name" />
        <Field name={`fwsize_${i}`} component={this.renderSelect} data={config.fw_sizes} label="FW Size" />
      </div>
    )
  }

  // renderCheckboxOption = () => {
  //   return (
  //     fsdf: 3
  //   )
  // }

  // renderCheckBox = (props) => {
  //   const { input, label, data } = props;
  //   return (
  //     <div className="inline fields">
  //       <label>{label}</label>
  //       <div className="field">
  //         <div className="ui radio checkbox">
  //           <input type="radio" name="frequency" checked="checked" />
  //           <label>Once a week</label>
  //         </div>
  //       </div>
  //       <div className="field">
  //         <div className="ui radio checkbox">
  //           <input type="radio" name="frequency" />
  //           <label>2-3 times a week</label>
  //         </div>
  //       </div>
  //     </div>

  //   )
  // }

  createProject = projectFields => {
    console.log(projectFields)
    this.props.createProject({ projectFields });
  };

  render() {
    return (
      <form onSubmit={this.props.handleSubmit(this.createProject)} className="ui form error">

      <div>

        <div className="ui segment">
            <h3 className="ui floated header">General Configuration</h3>
            <div className="ui clearing divider"></div>

          <Field name="subscriptionID" component={this.renderInput} label="Azure Subscription ID" />
          <Field name="projectType" component={this.renderSelect} data={config.projectType} label="Project Type" />
        </div>

        <div className="ui horizontal divider"></div>

        <div className="ui segment">
          <h3 className="ui floated ">Transit VNet</h3>

          {/* Firewall Configuration*/}
          <h4 className="ui horizontal divider header">
            <i className="cloud icon"></i>
            Firewall Configuration
          </h4>
  
          <Field name="fwusername" component={this.renderInput} label="FW Username" />
          <Field name="fwpassword" password component={this.renderInput} label="FW Password" />
          <Field name="fwcount" component={this.renderSelect} data={config.fw_count_options} label="Number of Firewalls" />


          {_.range(this.props.fwcount).map(this.renderFWBlock)}


          {/* VNET Configuration*/}
          <h4 className="ui horizontal divider header">
            <i className="cloud icon"></i>
            VNet Configuration
          </h4>

          <Field name="transitVnetname" component={this.renderInput} label="VNet Name" />
          <Field name="transitVnetnetwork" component={this.renderInput} label="VNet Network" />
          <Field name="vnetPeerCount" component={this.renderSelect} data={config.vnet_peers} label="Number of VNet Peers" />

        </div>



      </div>

      <div style={{marginTop:'10px'}}>
        <button className="ui button primary">Submit</button>
      </div>

      </form>
    );
  }
}

const validate = formValues => {
  const errors = {};

  // if (!formValues.subscriptionID) {
  //   errors.subscriptionID = 'You must enter a subscription ID';
  // }


  return errors;
};

const selector = formValueSelector('azureForm')

const mapStatetoProps = (state) => {
  //console.log(state)
  return { 
    fwcount: selector(state, 'fwcount'), 
    projectType: selector(state, 'projectType'), 
    userId: state.auth.userId
  }
}

export default connect(mapStatetoProps, { createProject } )(reduxForm({
  form: 'azureForm',
  validate
})(Azure));