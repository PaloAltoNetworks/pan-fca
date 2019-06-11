const mongoose = require('mongoose');
const fs = require('fs');
const Schema = mongoose.Schema;

const terraformSchema = new Schema({
  projectId: mongoose.Schema.Types.ObjectId,
  createdDate: { type: Date, default: Date.now, required: true },
  tfStateType: { type: String }, //INFRASTRUC
  tfStage: { type: String, default: "INIT" }, //INIT, INPROGRESS, COMPLETED
  tfFile: { type: Buffer },
  tfStateFile: { type: Buffer }
})

module.exports = mongoose.model('terraform', terraformSchema);
