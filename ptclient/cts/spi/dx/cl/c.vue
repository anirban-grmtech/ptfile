<template>
  <div>
    <el-form>
      <el-form-item>
        <el-input
          type="textarea"
          :autosize="{ minRows: 2, maxRows: 4 }"
          :value="getDxDescUsingCache()"
          @input="setDxDescInVstOnDelay($event)"
        ></el-input>
        <!-- setDxDescInVstOnDelay -> Full form: Set diagnosis description in view state on delay -->
      </el-form-item>
      <el-form-item>
        <el-button type="primary" size="mini" plain @click="sendDataToServer"
          >Submit<!-- firstpapram is {{ this.firstParam }}--></el-button
        >
      </el-form-item>
    </el-form>

    <!-- Goal show history of this diagnosis -->
    <el-timeline style="padding-inline-start: 20px;">
      <el-timeline-item
        v-for="row in cfTimeLineDataAr"
        :key="row.ROW_START"
        :timestamp="row.createdAt"
        :type="row.type"
      >
        {{ row.dxName }}
      </el-timeline-item>
    </el-timeline>
  </div>
</template>
<script>
import { DIAGNOSIS_API_URL } from '../const.js'
import ormDx from '@/cts/spi/dx/db/vuex-orm/dx.js'
export default {
  /* Why is this called firstParam
        This Ct is called in a for loop. In the same for loop other Ct are also called.
        So the param name has to be generic and cannot be unique to each Ct
    */
  props: ['firstParam'], // this is the unique row id created by vuex-orm
  data() {
    return {
      diagnosisDescCached: '',
      uuid: '',
      ORMRowIDForPreviousInvocation: 0,
      vOrmSaveScheduled: '',
    }
  },
  computed: {
    cfRowInEditStateOnClient() {
      const arFromORM = ormDx
        .query()
        .where('rowStateInThisSession', 3) // Copy -> Changed
        .orWhere('rowStateInThisSession', 34) // Copy -> Changed
        .orWhere('rowStateInThisSession', 3456) // Copy -> Changed -> Requested save -> form error
        .where((_record, query) => {
          query.where('uuid', this.uuid)
        })
        .get()
      console.log(arFromORM)
      return arFromORM
    },
    cfTimeLineDataAr() {
      // console.log('inside computed function the UUID is', this.uuid)
      const dataTable = []

      // to create timeline the uuid will be same but id will be different.
      const arFromORM = ormDx.query().where('uuid', this.uuid).orderBy('ROW_START', 'desc').get()
      console.log('Time line if for uuid', this.uuid)
      if (arFromORM.length) {
        let obj = []
        let date = ''
        // console.log('sending this to timeline', arFromORM, arFromORM[0].uuid)
        for (let i = 0; i < arFromORM.length; i++) {
          obj = {}
          obj.dxName = arFromORM[i].dxName
          /*
          To get the number of the month:
          obj.createdAt = date.getMonth() + 1 + "-" + date.getDate()

          To get the name of the month:
          Ref: https://stackoverflow.com/questions/1643320/get-month-name-from-date
          */
          date = new Date(arFromORM[i].ROW_START)
          obj.createdAt = date.toLocaleString('default', { month: 'long' }) + '-' + date.getDate()
          if (
            arFromORM[i].rowStateInThisSession === 3 ||
            arFromORM[i].rowStateInThisSession === 34 ||
            arFromORM[i].rowStateInThisSession === 3456
          ) {
            obj.type = 'warning' // row is being edited and is not on server
          } else {
            obj.type = ''
          }
          obj.ROW_START = arFromORM[i].ROW_START
          dataTable.push(obj)
        }
      }
      // console.log(dataTable)
      return dataTable
    },
  },
  mounted() {},
  methods: {
    addEmptyDxToUI(pDesc) {
      console.log('Add dx called')
      const arFromORM = ormDx.insert({
        data: {
          dxName: pDesc,
          uuid: this.uuid,
          rowStateInThisSession: 3, // For meaning of diff values read dx/db/vuex-orm/dx.js:71
          ROW_START: Math.floor(Date.now() / 1000), // Ref: https://stackoverflow.com/questions/221294/how-do-you-get-a-timestamp-in-javascript
        },
      })
      console.log(arFromORM)
    },
    getDxDescUsingCache() {
      /* Performance analysis
         When C is first clicked and the control comes here. This fn is called twice
         Since following console.log is written twice.
         If I remove :value="getDxDescUsingCache()" then this fn is called 0 times

         Why?
         It is a default browser behavior. Clicking on the <label> will trigger 2 clicks, one for <label> and one for <input>.
         Ref: https://stackoverflow.com/a/58724163

         This fn is fired once when the property is first defined with undefined value and then is fired twice when a value is assigned to it.

        */

      /* When to get from ORM and when from cache?
         Inside get desc. 1st time it comes from ORM from then on it always come from cache. The cache value is set by setDxDesc
        */

      console.log('in get desc from cache fn')

      /* States: For the paramters supplied to this Ct.
                 1. Repeat invocatoion => 1.1 no unsaved data 1.2 there is unsaved data
                 2. First time invocation => 2.1 no unsaved data 2.2 there is unsaved data 

        What are the different times this function is called?
          1. User types multiple keystrokes. This fn is called for each keystroke
          2. User click C from the table. Uses esc key to closes the tab and then again clicks C
          3. User click C from table clicks cross to exit the tab and then again click C

          1st click on C -> 1 fti / 1 ri 
                      each keystroke -> ri 2 times   
                                                    close tab by clicking outside modal -> 
                                                                                then click same C -> NO  fti / ri                                                                                
                                                                                then click different C -> 1 fti / 1 ri
                                                    close tab by clicking cross -> then click same C -> -> 1 fti / 1 ri 
        */

      // Goal: decide if it is repeat or first invocation
      let arFromORM = []
      if (this.ORMRowIDForPreviousInvocation === this.firstParam) {
        console.log('this is repeat invocation')
        // this.uuid is already existing
        // the new empty row where the user can type is already existing
      } else {
        // this is first time this Ct has been called with this parameter
        console.log('this is first time invocation')
        this.ORMRowIDForPreviousInvocation = this.firstParam
        arFromORM = ormDx.find(this.firstParam)
        this.uuid = arFromORM.uuid
        this.diagnosisDescCached = null
        console.log('Find if there is unsaved data', this.uuid)
        const arEditRowsFromORM = this.cfRowInEditStateOnClient
        // console.log(arFromORM)
        if (!arEditRowsFromORM.length) {
          console.log('adding a new blank record. Since this is temporal DB')
          this.addEmptyDxToUI(arFromORM.dxName)
        }
      }

      // From this point on the state is the same.

      if (!this.diagnosisDescCached) {
        console.log(
          'Going to run query on vuexORM since for this parameter data has never been fetched from vuex-orm'
        )
        return this.getDxDescFromVst()
      } else {
        console.log('Better perf: Returning without running query on vuexORM')
        return this.diagnosisDescCached
      }
    },

    getDxDescFromVst() {
      // Full form: Get diagnosis description from view state.

      // Goal: Get the latest data with this UUID. Since there can be 2 rows with the same UUID hence important to get latest row with the same UUID
      const arFromORM = ormDx.query().where('uuid', this.uuid).orderBy('id', 'desc').get()
      console.log(arFromORM, this.uuid)
      if (arFromORM.length > 0) {
        // console.log(arFromORM)
        this.newRowIDfromORM = arFromORM[0].id
        return arFromORM[0].dxName
      } else {
        return 'ERROR: This is not possible'
      }
    },

    // state updates are smarter.
    setDxDescInVstOnDelay(pEvent) {
      // Full form: Set diagnosis in vue state on delay
      if (this.vOrmSaveScheduled) {
        console.log('clearing timeout')
        clearTimeout(this.vOrmSaveScheduled)
      }

      /* Ref: https://stackoverflow.com/questions/38399050/vue-equivalent-of-settimeout */
      this.vOrmSaveScheduled = setTimeout(
        function (scope) {
          scope.setDxDescInVst(pEvent)
        },
        1000,
        this
      )

      this.diagnosisDescCached = pEvent
    },

    setDxDescInVst(pEvent) {
      console.log('Inside setDxDesc')
      ormDx.update({
        where: this.newRowIDfromORM,
        data: {
          dxName: pEvent,
          rowStateInThisSession: 34,
        },
      })
    },

    async sendDataToServer() {
      try {
        const response = await fetch(`${DIAGNOSIS_API_URL}/${this.uuid}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json;charset=utf-8',
            // "Authorization": "Bearer " + TOKEN
          },
          body: JSON.stringify({
            dxName: this.getDxDescUsingCache(),
          }),
        })
        if (!response.ok) {
          console.log('Failed to update')
        } else {
          console.log('update success')
        }
      } catch (ex) {}

      console.log('sendDataToServer-> ', this.uuid, this.getDxDescUsingCache())
    },
  },
}
</script>
