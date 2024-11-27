import pandas as pd
import psycopg2


class PostgresConnection:

    def __init__(self, config: dict) -> None:
        """
        Constructor

        Args:
            config (dict): Configuration Dictionary
        """
        self.config = config

    def _connection(self):
        """
        Build the connection to Postgres Server

        Returns:
           Postgres connection
        """
        return psycopg2.connect(
            database=self.config['POSTGRES_DB'],
            user=self.config['POSTGRES_USER'],
            password=self.config['POSTGRES_PASSWORD'],
            port=self.config['HOST_PORT'])
    
    def read_sql(self, sql: str) -> pd.DataFrame:
        """
        Download the sql statement from postgres server

        Args:
            sql (str): Sql command

        Returns:
            pd.DataFrame: DataFrame with result
        """
        return pd.read_sql(sql, self._connection())
    
    def read_table(self, table: str) -> pd.DataFrame:
        """
        Return sql results as a table

        Args:
            table (str): table name to pull data for

        Returns:
            pd.DataFrame: Table as a DataFrame
        """
        return self.read_sql(sql=f"SELECT * from {table}")