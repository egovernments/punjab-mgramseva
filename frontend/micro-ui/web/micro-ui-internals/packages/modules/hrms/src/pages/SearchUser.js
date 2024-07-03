import React from 'react'
import SearchUserForm from '../components/SearchUserForm'
import { Header } from '@egovernments/digit-ui-react-components'
import { useTranslation } from "react-i18next";


const SearchUser = () => {
  const {t} = useTranslation()

  return (
    <div className="inbox-search-component-wrapper">
      <div className={`sections-parent search`}>
        <Header >{t("HR_SU")}</Header>
        <SearchUserForm />
      </div>
    </div>
  )
}

export default SearchUser