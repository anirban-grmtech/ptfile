<!-- When  i went from 80 to 100 the line count went rom 276 to 230 -->
<template>
  <div>
    <dbInteraction></dbInteraction>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>Diagnoses</span>
        <el-button-group style="float: right;">
          <el-button style="padding: 3px;" type="success" plain @click="mfOpenADialog">A</el-button>
          <el-button style="padding: 3px;" type="primary" plain @click="mfOpenMDialog">M</el-button>
          <el-button style="padding: 3px;" type="warning" plain @click="mfOpenDDialog">D</el-button>
          <el-button style="padding: 3px;" type="info" plain @click="mfOpenXDialog">X</el-button>
        </el-button-group>
      </div>
      <el-table
        :data="cfArOfDxForDisplayInTable"
        :show-header="false"
        size="mini"
        style="width: 100%;"
        :stripe="true"
        :row-class-name="mfGetDirtyClassName"
      >
        <el-table-column type="expand">
          <template slot-scope="props">
            <p>Created: {{ props.row.createdAt }}</p>
            <p>Row start: {{ props.row.ROW_START }}</p>
            <p>Row end: {{ props.row.ROW_END }}</p>
            <p>uuid: {{ props.row.uuid }}</p>
            <p>id: {{ props.row.id }}</p>
          </template>
        </el-table-column>

        <el-table-column prop="dxName" label="Desc"> </el-table-column>
        <!-- Why is width = "60" for the action column
        Setting this makes the middle column of desc flexible.
        After this is set if desc has 200 words they will use the maximum available space.
          -->
        <el-table-column label="Actions" width="60">
          <template slot-scope="props">
            <el-button-group>
              <el-button
                type="primary"
                size="mini"
                style="padding: 3px;"
                plain
                @click="mfOpenCDialog(props.row.$id)"
                >C</el-button
              >
              <el-button type="warning" size="mini" style="padding: 3px;" plain>D</el-button>
            </el-button-group>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        :hide-on-single-page="true"
        background
        layout="pager"
        :total="cfLengthOfDataArray"
        @current-change="mfTablePageChanged"
      >
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
import dbInteraction from '../db-interaction'
import ormSearchPhraseUiToCT from '@/cts/core/vl-search-box/vuex-orm/searchPhrasesOfCt'
import ormDx from '@/cts/spi/dx/db/vuex-orm/dx.js'

export default {
  components: { dbInteraction },
  data() {
    return {
      tablePageNumber: 1,
    }
  },
  computed: {
    cfGetUniqueDiagnoses() {
      const arFromORM = ormDx.query().where('ROW_END', 2147483647.999999).get()

      const uniqueUUIDDiagnoses = []

      // Goal: Find unique UUIDs since it is possible that some UUID is being changed and now there are 2 records with same UUID

      let breakCheck1 = false
      for (let i = 0; i < arFromORM.length; i++) {
        for (let j = 0; j < uniqueUUIDDiagnoses.length; j++) {
          if (arFromORM[i].uuid === uniqueUUIDDiagnoses[j].uuid) {
            breakCheck1 = true
            break
          }
        }
        if (breakCheck1) break
        uniqueUUIDDiagnoses.push(arFromORM[i])
      }

      return uniqueUUIDDiagnoses
    },

    cfLengthOfDataArray() {
      const arFromORM = this.cfGetUniqueDiagnoses
      return arFromORM.length
    },

    cfArOfDxForDisplayInTable() {
      console.log(
        'cfArOfDxForDisplayInTable called. Whenever ormDx will change this will get called. Even when there are 100 rows in the table when orm dx changes this gets called once'
      )

      const arFromORM = this.cfGetUniqueDiagnoses

      /*  Q) Should this function return the array it gets from ORM or modify the array?
              Option1: Return origianl array
                  -ves:
                    Created at needs to be made inside the template
                    vue will get more data since when I loop here I can send less data to vue
                  +ves:
                    No need to run the for loop
      */

      /* Option2 of returning data from this cf:
       */
      const arDxsForDisplay = []
      let obj = {}
      if (arFromORM.length) {
        let date = ''
        const startDataRowInidex = (this.tablePageNumber - 1) * 10
        const endDataRowIndex = startDataRowInidex + 10
        for (let i = startDataRowInidex; i < arFromORM.length && i < endDataRowIndex; i++) {
          obj = {}
          obj.dxName = arFromORM[i].dxName
          // For date format ref: /cts/spi/dx/vl/timeline.vue:53
          date = new Date(arFromORM[i].ROW_START)
          obj.createdAt = date.toLocaleString('default', { month: 'long' }) + '-' + date.getDate()
          obj.rowStateInThisSession = arFromORM[i].rowStateInThisSession
          obj.uuid = arFromORM[i].uuid
          obj.$id = arFromORM[i].$id
          obj.id = arFromORM[i].id
          arDxsForDisplay.push(obj)
        }
      }
      return arDxsForDisplay
    }, // end of cfArOfDxForDisplayInTable
  },
  mounted() {},
  methods: {
    mfTablePageChanged(pNewPageNumber) {
      console.log('Page changed', pNewPageNumber)
      this.tablePageNumber = pNewPageNumber
    },
    mfOpenADialog() {
      // console.log('show add dialog')
      const arFromORM = ormSearchPhraseUiToCT.query().search('add diagnosis').get()
      const objSearchRowFromORM = arFromORM[0]
      // console.log(objSearchRowFromORM)
      const tab = {
        label: objSearchRowFromORM.value,
        ctToShow: require('@/cts/' + objSearchRowFromORM.ctToShowInCL).default,
        ctAbbr: objSearchRowFromORM.ctAbbr,
        id: objSearchRowFromORM.id,
        closable: true,
      }
      this.$store.commit('mtfShowNewFirstTabInCl', tab)
    },
    mfOpenMDialog() {
      // console.log('show add dialog')
      const arFromORM = ormSearchPhraseUiToCT.query().search('multi change diagnosis').get()
      const objSearchRowFromORM = arFromORM[0]
      // console.log(objSearchRowFromORM)
      const tab = {
        label: objSearchRowFromORM.value,
        ctToShow: require('@/cts/' + objSearchRowFromORM.ctToShowInCL).default,
        ctAbbr: objSearchRowFromORM.ctAbbr,
        id: objSearchRowFromORM.id,
        closable: true,
      }
      this.$store.commit('mtfShowNewFirstTabInCl', tab)
    },
    mfOpenDDialog() {
      // console.log('show add dialog')
    },
    mfOpenXDialog() {
      // console.log('show add dialog')
      const arFromORM = ormSearchPhraseUiToCT.query().search('discontinued diagnoses').get()
      const objSearchRowFromORM = arFromORM[0]
      // console.log(objSearchRowFromORM)
      const tab = {
        label: objSearchRowFromORM.value,
        ctToShow: require('@/cts/' + objSearchRowFromORM.ctToShowInCL).default,
        ctAbbr: objSearchRowFromORM.ctAbbr,
        id: objSearchRowFromORM.id,
        closable: true,
      }
      this.$store.commit('mtfShowNewFirstTabInCl', tab)
    },
    mfOpenCDialog(pORMDataRowID) {
      console.log('Open change dx dialog -> ', pORMDataRowID)

      // Goal: Find out which CT will handle this work
      const arFromORM = ormSearchPhraseUiToCT.query().search('change diagnosis').get()
      const objSearchRowFromORM = arFromORM[0]
      // console.log(objSearchRowFromORM)

      // Goal: Create the obj Tab that will be worked upon by for loop in
      // /cts/core/cl-tabs-manager/ctShowAddAndDxoveTabsInDialog.vue: 76

      /*
       We need rowID of vuexORM inside the change ct. Since change ct needs the exiting Desc of the diagnosis to change
       Option 1: Send the whole data row
       Option 2: Send just the ID in a prop.
        +ves:
          1. At some places I may need to call change where I have the diagnosis ID but
          i do not have the diagnosis of the data row. Hence this makes the Change Ct possible
          to use at other places
          2. When I send a paramter it is like calling a function. Sending the whole data row
          is like working on a gloal variable. So other Cts can also modify this global variable.
      */

      const tab = {
        label: objSearchRowFromORM.value, // TODO: Should be called vsLabel
        /*
        import and require are similar
        require can use a variable.
        import cannot use a variable. Benefits: webpack optimization
        How optimize? Webpack can remove that module completely if module is not used

        What does .default do?
        Related to webpack and HMR (Hot module reload)
        Ref: https://stackoverflow.com/questions/46215705/why-need-default-after-require-method-in-vue

        */
        ctToShow: require('@/cts/' + objSearchRowFromORM.ctToShowInCL).default,
        ctAbbr: objSearchRowFromORM.ctAbbr, // TODO: Should be called vsCtAbbr
        id: objSearchRowFromORM.id, // This id comes from search phrases UI to Ct. TODO: should be called vnID
        vstPropsToGiveToCt: pORMDataRowID, // This holds all the data for the record we want to change in cl
        closable: true, // TODO: Should be called blClosable
      }
      // console.log(tab)
      this.$store.commit('mtfShowNewFirstTabInCl', tab)
    },
    mfGetDirtyClassName(pRow, pIndex) {
      const strOfNumber = pRow.row.rowStateInThisSession.toString()
      const lastCharecter = strOfNumber.slice(-1)
      console.log('pRow', pRow, 'pIndex', pIndex, 'Last charecter', lastCharecter)
      if (lastCharecter === '3' || lastCharecter === '4' || lastCharecter === '6') {
        return 'unsaved-data'
      } else {
        return ''
      }
    },
  },
}
</script>

<style>
tr.el-table__row.unsaved-data {
  background: #fde2b9;
}
.el-table--striped .el-table__body tr.el-table__row--striped.unsaved-data td {
  background: #f9d399;
}
</style>
